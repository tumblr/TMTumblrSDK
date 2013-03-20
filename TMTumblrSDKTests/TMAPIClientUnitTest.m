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

- (void) assertCallback:(void(^)(id, TMAPICallback))action andVerify:(JXHTTPOperation*)op {
    // Create a partial mock
    id mClient = [OCMockObject partialMockForObject:self.client];
    // Set up an expectation object
    NSDictionary *expectation = @{ @"some": @"data" };
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // Grab the callback and make sure we actually hit it
    [[[mClient stub] andDo:^(NSInvocation *invoc) {

        TMAPICallback cbk;
        [invoc getArgument:&cbk atIndex:3];
        cbk(expectation, nil);

        if (op != nil) {
            __unsafe_unretained JXHTTPOperation *oop;
            [invoc getArgument:&oop atIndex:2];
            [self assertSimilarRequest:op to:oop];
        }

        dispatch_semaphore_signal(semaphore);

    }] sendRequest:[OCMArg isNotNil] callback:[OCMArg any]];
    // And then make the call and make sure we receive the proper data
    TMAPICallback check = ^(NSDictionary *data, NSError *error) {
        STAssertEquals(data, expectation, @"unexpected response");
    };
    action(mClient, check);
    // Chill
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

- (void) assertSimilarRequest:(JXHTTPOperation*)op1 to:(JXHTTPOperation*)op2 {
    [self assertMethod:op1 is:[op2 requestMethod]];
    [self assertPath:op1   is:[[[op2 request] URL] path]];

    // Conditional query check
    NSString *oquery = [[[op2 request] URL] query];
    if (oquery != nil) {
        [self assertQuery:op1 is:oquery];
    }

    // Conditional body check
    if ([[op2 requestBody] isKindOfClass:[JXHTTPFormEncodedBody class]]) {
        JXHTTPFormEncodedBody *obody = (JXHTTPFormEncodedBody *) [op2 requestBody];
        NSDictionary *odict = [obody dictionary];

        if (odict != nil) {
            [self assertBody:op1 is:odict];
        }
    }

    // TODO conditional multipart check
}

- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected {
    // JXHTTPMultipartBody *body = (JXHTTPMultipartBody *) [op requestBody];
    // NSLog(@"%lld", [body httpContentLength]);
    // TODO multipart check
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
