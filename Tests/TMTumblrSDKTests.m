//
//  TMTumblrSDKTests.m
//  Tumblr SDK
//
//  Created by Bryan Irace on 8/23/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMTumblrSDKTests.h"

#import "TMAPIClient.h"

@implementation TMTumblrSDKTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBlogInfo {
    [[TMAPIClient sharedInstance] blogInfo:@"bryan" success:^(NSDictionary *result) {
        NSLog(@"Result: %@", result);
        
        STAssertNotNil(result, nil);
    } error:nil];
}

@end
