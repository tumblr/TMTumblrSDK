//
//  TMOAuthAuthenticator.m
//  Pods
//
//  Created by Tyler Tape on 4/12/17.
//
//

#import "TMOAuthAuthenticator.h"
#import "TMURLSession.h"
#import "TMHTTPRequest.h"
#import "TMFormEncodedRequestBody.h"
#import "TMOAuth.h"
#import "TMAuthenticationResponseProcessor.h"
#import "TMRequestMethodHelpers.h"
#import "TMAuthenticationConstants.h"
#import "TMAuthTokenRequestGenerator.h"
#import "TMSDKFunctions.h"

@interface TMOAuthAuthenticator()

@property (nonatomic, nonnull, readonly) id <TMSession>session;
@property (nonatomic, nonnull, readonly) TMAPIApplicationCredentials *applicationCredentials;
@property (nonatomic, readonly, weak) id <TMOAuthAuthenticatorDelegate> delegate;

@property (nonatomic, copy) TMAuthenticationCallback threeLeggedOAuthCallback;
@property (nonatomic, copy) NSString *threeLeggedOAuthTokenSecret;

@end

@implementation TMOAuthAuthenticator

- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session
                 applicationCredentials:(nonnull TMAPIApplicationCredentials *)applicationCredentials
                               delegate:(nonnull id <TMOAuthAuthenticatorDelegate>)delegate {
    NSParameterAssert(session);
    NSParameterAssert(applicationCredentials);
    NSParameterAssert(delegate);
    self = [super init];

    if (self) {
        _session = session;
        _applicationCredentials = applicationCredentials;
        _delegate = delegate;
    }

    return self;
}

- (void)authenticate:(NSString *)URLScheme callback:(TMAuthenticationCallback)callback {
    // Clear token secret in case authentication was previously started but not finished
    self.threeLeggedOAuthTokenSecret = nil;

    TMAuthenticationResponseProcessor *responseProcessor = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials *userCredentials, NSError *error) {

        if (error) {
            if (callback) {
                callback(nil, error);
            }

            return;
        }

        self.threeLeggedOAuthCallback = callback;
        self.threeLeggedOAuthTokenSecret = userCredentials.tokenSecret;

        NSURL *authURL = [NSURL URLWithString:
                          [NSString stringWithFormat:@"https://www.tumblr.com/oauth/authorize?oauth_token=%@",
                           userCredentials.token]];

        [self.delegate openURLInBrowser:authURL];
    }];

    TMHTTPRequest *tokenRequest = [[[TMAuthTokenRequestGenerator alloc] initWithURLScheme:URLScheme] authTokenRequest];

    NSURLSessionTask *tokenRequestTask = [self.session taskWithRequest:tokenRequest
                                                     completionHandler:responseProcessor.sessionCompletionBlock];

    [tokenRequestTask resume];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:@"tumblr-authorize"]) {
        return NO;
    }

    void(^clearState)() = ^ {
        self.threeLeggedOAuthTokenSecret = nil;
        self.threeLeggedOAuthCallback = nil;
    };

    NSDictionary *URLParameters = TMQueryStringToDictionary(url.query);

    if ([[URLParameters allKeys] count] == 0) {
        if (self.threeLeggedOAuthCallback) {
            self.threeLeggedOAuthCallback(nil, [NSError errorWithDomain:@"Permission denied by user" code:0 userInfo:nil]);
        }

        clearState();

        return NO;
    }

    NSString *oAuthToken = URLParameters[@"oauth_token"];

    NSDictionary *requestParameters = @{ @"oauth_verifier" : URLParameters[@"oauth_verifier"] };

    NSString *urlString = @"https://www.tumblr.com/oauth/access_token";

    TMFormEncodedRequestBody *requestBody = [[TMFormEncodedRequestBody alloc] initWithBody:requestParameters];

    TMHTTPRequest *request = [[TMHTTPRequest alloc] initWithURLString:urlString method:TMHTTPRequestMethodPOST additionalHeaders:nil requestBody:requestBody isSigned:NO isUpload:NO];

    TMAuthenticationResponseProcessor *responseProcessor = [[TMAuthenticationResponseProcessor alloc] initWithCallback:^(TMAPIUserCredentials *userCredentials, NSError *error) {
        if (error) {
            if (self.threeLeggedOAuthCallback) {
                self.threeLeggedOAuthCallback(nil, error);
            }
        }
        else {
            self.threeLeggedOAuthCallback(userCredentials, nil);
        }

        clearState();
    }];

    id <TMRequest> signedRequest = [self signAccessTokenRequest:request withOAuthToken:oAuthToken];
    NSURLSessionTask *task = [self.session taskWithRequest:signedRequest completionHandler:responseProcessor.sessionCompletionBlock];
    
    [task resume];
    
    return YES;
}

#pragma mark - Private

- (id <TMRequest>)signAccessTokenRequest:(TMHTTPRequest *)request withOAuthToken:(NSString *)oAuthToken {
    NSDictionary *postParameters = (request.method == TMHTTPRequestMethodPOST && [request.requestBody encodeParameters]) ? [request.requestBody parameters] : nil;
    NSString *authHeader = [TMOAuth headerForURL:request.URL
                                          method:[TMRequestMethodHelpers stringFromMethod:request.method]
                                  postParameters:postParameters
                                           nonce:[[NSUUID UUID] UUIDString]
                                     consumerKey:self.applicationCredentials.consumerKey
                                  consumerSecret:self.applicationCredentials.consumerSecret
                                           token:oAuthToken
                                     tokenSecret:self.threeLeggedOAuthTokenSecret];

    return [request requestByAddingAdditionalHeaders:@{AuthorizationHeaderField : authHeader}];
}

@end
