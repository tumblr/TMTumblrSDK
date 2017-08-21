//
//  TMAuthTokenRequestGenerator.m
//  Pods
//
//  Created by Tyler Tape on 5/4/17.
//
//

#import "TMAuthTokenRequestGenerator.h"
#import "TMSDKFunctions.h"

@interface TMAuthTokenRequestGenerator ()

@property (nonatomic, readonly) NSString *urlScheme;

@end

@implementation TMAuthTokenRequestGenerator

- (instancetype)initWithURLScheme:(NSString *)urlScheme {
    self = [super init];
    if (self) {
        _urlScheme = [urlScheme copy];
    }
    return self;
}

- (TMHTTPRequest *)authTokenRequest {
    NSString *tokenRequestURLString = [NSString stringWithFormat:@"https://www.tumblr.com/oauth/request_token?oauth_callback=%@",
                                       TMURLEncode([NSString stringWithFormat:@"%@://tumblr-authorize", self.urlScheme])];

    return [[TMHTTPRequest alloc] initWithURLString:tokenRequestURLString method:TMHTTPRequestMethodGET additionalHeaders:nil requestBody:nil isSigned:YES isUpload:NO];
}

@end
