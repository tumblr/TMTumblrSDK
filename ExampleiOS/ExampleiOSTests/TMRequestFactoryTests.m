//
//  TMRequestFactoryTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/16/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMRequestFactoryTests : XCTestCase

@end

@implementation TMRequestFactoryTests

- (void)testPOSTRequestMethodIsAPOSTRequest {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory POSTRequestWithPath:@"/" JSONParameters:@{}];

    XCTAssert(request.method == TMHTTPRequestMethodPOST);
}

- (void)testPermalinkFactoryMethod {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] init];

    id <TMRequest> request = [requestFactory permalinkRequestWithBlogName:@"pearapps" postID:@"ken"];

    XCTAssertEqualObjects(@"https://api.tumblr.com/v2/blog/pearapps.tumblr.com/posts/ken/permalink", request.URL.absoluteString);
}

- (void)testPermalinkFactoryMethodUUID {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] init];

    id <TMRequest> request = [requestFactory permalinkRequestWithBlogUUID:@"sdihoadspfhdsoiao" postID:@"ken"];

    XCTAssertEqualObjects(@"https://api.tumblr.com/v2/blog/sdihoadspfhdsoiao/posts/ken/permalink", request.URL.absoluteString);
}

@end
