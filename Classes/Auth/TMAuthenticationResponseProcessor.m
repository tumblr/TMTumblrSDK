//
//  TMAuthenticationResponseProcessor.m
//  Pods
//
//  Created by Kenny Ackerson on 6/14/16.
//
//

#import "TMAuthenticationResponseProcessor.h"
#import "TMXAuthAuthenticator.h"
#import "TMURLSessionCallbacks.h"
#import "TMSDKFunctions.h"
#import "TMAPIUserCredentials.h"

@interface TMAuthenticationResponseProcessor ()

@property (nonatomic, copy, readonly, nonnull) TMAuthenticationCallback callback;

@end

@implementation TMAuthenticationResponseProcessor

- (nonnull instancetype)initWithCallback:(nonnull TMAuthenticationCallback)callback {
    NSParameterAssert(callback);
    self = [super init];

    if (self) {
        _callback = [callback copy];
    }
    
    return self;
}

- (TMURLSessionRequestCompletionHandler)sessionCompletionBlock {
    return ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSInteger const passwordStatusCode = 415;
        NSInteger const successStatusCode = 200;

        if (error) {
            if (self.callback) {
                self.callback(nil, error);
            }

            return;
        }
        if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = urlResponse.statusCode;

            if (statusCode == successStatusCode) {
                NSDictionary *responseParameters = formEncodedDataToDictionary(data);

                if (self.callback) {
                    id secret = responseParameters[@"oauth_token_secret"];
                    id token = responseParameters[@"oauth_token"];

                    if ([secret isKindOfClass:[NSString class]] && [token isKindOfClass:[NSString class]]) {
                        self.callback([[TMAPIUserCredentials alloc] initWithToken:token tokenSecret:secret], nil);
                        return;
                    }

                    // API gave us bad types, we can not send anything useful back
                    self.callback(nil, [[NSError alloc] initWithDomain:@"com.tumblr.sdk" code:3400 userInfo:nil]);
                }
            }
            else {
                if (self.callback) {

                    NSDictionary *allheaders = urlResponse.allHeaderFields;
                    if (allheaders[@"Password-Status"] != nil) {
                        statusCode = passwordStatusCode;
                    }

                    
                    self.callback(nil, errorWithStatusCode(statusCode));
                }
            }
        }
    };
}

#pragma mark - Helpers

NSError *errorWithStatusCode(NSInteger statusCode) {
    return [NSError errorWithDomain:@"Authentication request failed" code:statusCode userInfo:nil];
}

NSDictionary *formEncodedDataToDictionary(NSData *data) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = TMQueryStringToDictionary(string);

    return dictionary;
}


@end
