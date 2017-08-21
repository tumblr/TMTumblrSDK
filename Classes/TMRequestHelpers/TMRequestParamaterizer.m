//
//  TMRequestParamaterizer.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 3/30/16.
//
//

#import "TMRequestParamaterizer.h"

#import "TMSDKFunctions.h"
#import "TMOAuth.h"
#import "NSMutableURLRequest+TMTumblrSDKAdditions.h"
#import "TMRequest.h"
#import "TMAPIApplicationCredentials.h"
#import "TMAPIUserCredentials.h"
#import "TMURLEncoding.h"
#import "TMRequestBody.h"
#import "TMRequestMethodHelpers.h"
#import "TMAuthenticationConstants.h"

@interface TMRequestParamaterizer ()

@property (nonatomic, readonly, nullable) TMAPIApplicationCredentials *applicationCredentials;
@property (nonatomic, nullable, readonly) TMAPIUserCredentials *userCredentials;
@property (nonatomic, nonnull, readonly) id <TMRequest> request;
@property (nonatomic, nullable, readonly) NSDictionary<NSString *, NSString *> *additionalHeaders;

@end

@implementation TMRequestParamaterizer

- (nonnull instancetype)initWithApplicationCredentials:(nullable TMAPIApplicationCredentials *)applicationCredentials
                                       userCredentials:(nullable TMAPIUserCredentials *)userCredentials
                                               request:(nonnull id <TMRequest>)request
                                     additionalHeaders:(nullable NSDictionary<NSString *, NSString *> *)additionalHeaders {
    NSParameterAssert(request);
    self = [super init];

    if (self) {
        _applicationCredentials = applicationCredentials;
        _userCredentials = userCredentials;
        _request = request;
        _additionalHeaders = additionalHeaders;
    }
    
    return self;
}

- (nonnull NSURLRequest *)URLRequestWithRequest:(nonnull id <TMRequest>)request {
    NSParameterAssert(request);

    NSURLRequest *URLRequest = ^NSURLRequest *(){
        NSParameterAssert(request);
        NSURL * _Nonnull URL = request.URL;

        NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        URLRequest.URL = [self parameterizeURL:URL parameters:request.queryParameters];

        [URLRequest addAdditionalHeaders:request.additionalHeaders];

        [URLRequest addAdditionalHeaders:self.additionalHeaders];

        id <TMRequestBody> requestBody = request.requestBody;

        /**
         *  Upload requests derive their body from the session task, and will not work if we set this unfortunately.
         */
        if (!request.isUpload) {
            NSData *bodyData = [requestBody bodyData];

            if (bodyData) {
                URLRequest.HTTPBody = bodyData;
            }
        }

        NSString *contentType = [requestBody contentType];

        if (contentType) {
            [URLRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        }

        URLRequest.HTTPMethod = [TMRequestMethodHelpers stringFromMethod:request.method];
        
        return [URLRequest copy];
    }();

    return request.isSigned ? [self signedURLRequestWithRequest:URLRequest] : URLRequest;
}

#pragma mark - Private

/**
 *  Takes a dictionary of query parameters and sets the appropriate query items for the URL
 *
 *  @param URL        The URL to set query items on
 *  @param parameters The parameters to add to the URL
 *
 *  @return A parameterized URL
 */
- (nullable NSURL *)parameterizeURL:(nonnull NSURL *)URL parameters:(nullable NSDictionary *)parameters {
    NSParameterAssert(URL);

    NSDictionary *(^DictionaryByAdding)(NSDictionary *dictionary, NSString *key, NSString *value) = ^ NSDictionary *(NSDictionary *dictionary, NSString *key, NSString *value) {
        NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
        [mutableDictionary setObject:value forKey:key];
        return [mutableDictionary copy];
    };

    if (self.applicationCredentials.consumerKey && self.request.isSigned) {
        parameters = DictionaryByAdding(parameters, @"api_key", self.applicationCredentials.consumerKey);
    }

    NSString *URLString = URL.absoluteString;

    if (parameters && parameters.count > 0) {
        URLString = [URL.absoluteString stringByAppendingFormat:@"?%@", [TMURLEncoding encodedDictionary:parameters]];
    }

    return [NSURL URLWithString:URLString];
}

/*
 The reason we can not use the @c TMRequest here (and must pass an @c NSURLRequest into this method) is because we 
 need to copy an a different copy than what the TMRequest provides.
 */
- (nonnull NSURLRequest *)signedURLRequestWithRequest:(nonnull NSURLRequest *)URLRequest {
    NSParameterAssert(URLRequest);

    NSMutableURLRequest *mutableRequest = [URLRequest mutableCopy];

    NSString *token = nil;
    NSString *tokenSecret = nil;

    if (self.userCredentials.token.length > 0
        && self.userCredentials.tokenSecret.length > 0) {
        token = self.userCredentials.token;
        tokenSecret = self.userCredentials.tokenSecret;
    }

    NSDictionary *postParameters = (self.request.method == TMHTTPRequestMethodPOST && [self.request.requestBody encodeParameters]) ? [self.request.requestBody parameters] : nil;
    [mutableRequest addValue:[TMOAuth headerForURL:mutableRequest.URL
                                            method:[TMRequestMethodHelpers stringFromMethod:self.request.method]
                                    postParameters:postParameters
                                             nonce:[[NSUUID UUID] UUIDString]
                                       consumerKey:self.applicationCredentials.consumerKey
                                    consumerSecret:self.applicationCredentials.consumerSecret
                                             token:token
                                       tokenSecret:tokenSecret]
          forHTTPHeaderField:AuthorizationHeaderField];

    return [mutableRequest copy];
}

@end
