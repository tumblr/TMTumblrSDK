//
//  TMAPIClientTagTest.m
//  TMTumblrSDK
//
//  Created by John Crepezzi on 3/20/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientTagTest.h"

@implementation TMAPIClientTagTest

@synthesize client;

- (void) testTaggedRequest {
    JXHTTPOperation *op = [client taggedRequest:@"something" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/tagged"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1&tag=something"];
}

- (void) testTagged {
    NSString *tag = @"tag";
    NSDictionary *params = @{ @"limit": @"1" };
    JXHTTPOperation *op = [client taggedRequest:tag parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient tagged:tag parameters:params callback:check];
    } andVerify:op];
}

- (void) testTaggedRequest_NoParameters {
    JXHTTPOperation *op = [client taggedRequest:@"something" parameters:nil];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/tagged"];
    [self assertQuery:op  is:@"api_key=consumer_key&tag=something"];
}

@end
