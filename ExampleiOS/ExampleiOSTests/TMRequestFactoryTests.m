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
- (void)testURLEncodingSimplePath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", @"simpleString"] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/simpleString"]);
}

- (void)testURLEncodingQuestionCharacterInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"didithappen?")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/didithappen%3F"]);
}

- (void)testURLEncodingSpaceCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"hat cat in ")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/hat%20cat%20in%20"]);
}

- (void)testURLEncodingHashCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"maybeATag#tag")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/maybeATag%23tag"]);
}

- (void)testURLEncodingPlusCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"who+why")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/who%2Bwhy"]);
}

- (void)testURLEncodingEqualCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"hat=cat")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/hat%3Dcat"]);
}

- (void)testURLEncodingForwardSlashCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"hat/cat")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/hat%2Fcat"]);
}

- (void)testURLEncodingBackwardSlashCharactersInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"hat\\cat")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/hat%5Ccat"]);
}

- (void)testURLEncodingAllSpecialCharactersInPathInLastPositionInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@", TMURLEncode(@"ij#ij+ij/ij/ij+=?\\")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/ij%23ij%2Bij%2Fij%2Fij%2B%3D%3F%5C"]);
}

- (void)testURLEncodingAllSpecialCharactersInPathInMiddlePositionInPath {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    id <TMRequest> request = [requestFactory requestWithPath:[NSString stringWithFormat:@"samplePathComponent1/samplePathComponent2/%@/samplePathComponent3", TMURLEncode(@"ij#ij+ij/ij/ij+=?\\")] method:TMHTTPRequestMethodGET queryParameters:nil];

    XCTAssert([request.URL.absoluteString isEqualToString:@"https://api.tumblr.com/v2/samplePathComponent1/samplePathComponent2/ij%23ij%2Bij%2Fij%2Fij%2B%3D%3F%5C/samplePathComponent3"]);
}

@end
