//
//  TMXAuthAuthenticator.m
//  TumblrAuthentication
//
//  Created by Kenny Ackerson on 4/1/16.
//  Copyright (c) 2016 Tumblr. All rights reserved.
//

#import "TMXAuthAuthenticator.h"

#import "TMOAuth.h"
#import "TMHTTPRequest.h"
#import "TMSDKUserAgent.h"
#import "TMURLSession.h"
#import "TMQueryEncodedRequestBody.h"
#import "TMAPIUserCredentials.h"
#import "TMAuthenticationResponseProcessor.h"
#import "TMTumblrSDKErrorDomain.h"
#import "TMResponseParser.h"

typedef void (^TMCompletionHandler)(NSData *, NSURLResponse *, NSError *);

@interface TMXAuthAuthenticator()

@property (nonatomic, nonnull, readonly) id <TMSession>session;

@end

@implementation TMXAuthAuthenticator

- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session {
    NSParameterAssert(session);
    self = [super init];

    if (self) {
        _session = session;
    }

    return self;
}

- (NSURLSessionTask *)xAuth:(NSString *)emailAddress password:(NSString *)password callback:(TMAuthenticationCallback)callback {
    return [self xAuth:emailAddress password:password authToken:nil callback:callback];
}

- (NSURLSessionTask *)xAuth:(NSString *)emailAddress
                   password:(NSString *)password
                  authToken:(NSString *)authToken
                   callback:(TMAuthenticationCallback)callback {
    return [self xAuth:emailAddress password:password authToken:authToken euResident:nil gdprIsAcceptableAge:nil gdprConsentCore:nil gdprConsentAds:nil gdprToken:nil callback:callback];
}

- (nonnull NSURLSessionTask *)xAuth:(nonnull NSString *)emailAddress
                           password:(nonnull NSString *)password
                          authToken:(nullable NSString *)authToken
                         euResident:(nullable NSString *)euResident
                gdprIsAcceptableAge:(nullable NSString *)gdprIsAcceptableAge
                    gdprConsentCore:(nullable NSString *)gdprConsentCore
                     gdprConsentAds:(nullable NSString *)gdprConsentAds
                          gdprToken:(nullable NSString *)gdprToken
                           callback:(nonnull TMAuthenticationCallback)callback {
    NSDictionary *requestParameters = ^NSDictionary *{
        NSMutableDictionary *parameters = @{
                                            @"x_auth_username" : emailAddress,
                                            @"x_auth_password" : password,
                                            @"x_auth_mode" : @"client_auth",
                                            }.mutableCopy;

        if (authToken) {
            parameters[@"x_auth_token"] = authToken;
        }
        if (euResident) {
            parameters[@"eu_resident"] = authToken;
        }
        if (gdprIsAcceptableAge) {
            parameters[@"gdpr_is_acceptable_age"] = authToken;
        }
        if (gdprConsentCore) {
            parameters[@"gdpr_consent_core"] = authToken;
        }
        if (gdprConsentAds) {
            parameters[@"gdpr_consent_first_party_ads"] = authToken;
        }
        if (gdprToken) {
            parameters[@"gdpr_auth_token"] = gdprToken;
        }

        return [parameters copy];
    }();

    TMHTTPRequest *HTTPRequest = [[TMHTTPRequest alloc] initWithURLString:@"https://www.tumblr.com/oauth/access_token"
                                                                   method:TMHTTPRequestMethodPOST
                                                        additionalHeaders:@{@"User-Agent": [TMSDKUserAgent userAgentHeaderString]}
                                                              requestBody:[[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:requestParameters]
                                                                 isSigned:YES
                                                                 isUpload:NO];

    return [self.session taskWithRequest:HTTPRequest completionHandler:[[[TMAuthenticationResponseProcessor alloc] initWithCallback:callback] sessionCompletionBlock]];
}

@end
