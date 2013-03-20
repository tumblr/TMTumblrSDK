//
//  TMAPIClientUnitTest.m
//  TumblrSDK
//
//  Created by John Crepezzi on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientUnitTest.h"

@implementation TMAPIClientUnitTest

@synthesize client = _client;

- (void) setUp {
    self.client = [TMAPIClient sharedInstance];
    [self.client setOAuthConsumerKey:@"consumer_key"];
}

/**
 Test Helpers
*/

- (void) assertCallback:(void(^)(id, TMAPICallback))action {
    // Create a partial mock
    id mClient = [OCMockObject partialMockForObject:self.client];
    // Set up an expectation object
    NSDictionary *expectation = @{ @"some": @"data" };
    // Grab the callback and make sure we actually hit it
    [[[mClient stub] andDo:^(NSInvocation *invoc) {

        TMAPICallback cbk;
        [invoc getArgument:&cbk atIndex:3];
        cbk(expectation, nil);

        // TODO test actual HTTP call here on JXHTTPOperation
        
    }] sendRequest:[OCMArg isNotNil] callback:[OCMArg any]];
    // And then make the call and make sure we receive the proper data
    TMAPICallback check = ^(NSDictionary *data, NSError *error) {
        STAssertEquals(data, expectation, @"unexpected response");
    };
    action(mClient, check);
}

- (void) assertSimilarRequest:(JXHTTPOperation*)op1 to:(JXHTTPOperation*)op2 {
    [self assertMethod:op1 is:[op2 requestMethod]];
    // TODO rest
}

- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected {
    JXHTTPMultipartBody *body = (JXHTTPMultipartBody *) [op requestBody];
    NSLog(@"%lld", [body httpContentLength]);
}

- (void) assertBody:(JXHTTPOperation*)op is:(NSDictionary*)expected {
    JXHTTPFormEncodedBody *body = (JXHTTPFormEncodedBody *) [op requestBody];
    STAssertEqualObjects([body dictionary], expected, @"wrong url");
}

- (void) assertQuery:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([[[op request] URL] query], expected, @"wrong request query");
}

-(void) assertPath:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([[[op request] URL] path], expected, @"wrong request path");
}

-(void) assertMethod:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([op requestMethod], expected, @"wrong request method");
}

@end
