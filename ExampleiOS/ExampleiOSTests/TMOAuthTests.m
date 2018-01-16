//
//  TMOAuthTests.m
//  ExampleiOSTests
//
//  Created by dave on 11/28/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMOAuth.h>

@interface TMOAuthTests : XCTestCase

@end

@implementation TMOAuthTests

- (void)testSignUrlWithQueryComponentCalculatesProperSignature {
    NSURL *signedURL = [TMOAuth signUrlWithQueryComponent:[NSURL URLWithString:@"https://tumblr.com/"]
                                                   method:@"GET"
                                           postParameters:[NSDictionary dictionary]
                                                    nonce:@"1234"
                                              consumerKey:@"consumerKey"
                                           consumerSecret:@"consumerSecret"
                                                    token:@"token"
                                              tokenSecret:@"tokenSecret"
                                                timestamp:@"1511967770"];
    XCTAssert([signedURL.absoluteString isEqualToString:@"https://tumblr.com/?oauth_consumer_key=consumerKey&oauth_nonce=1234&oauth_signature=w/LP1MdJwiCfakR3GbW9IoeOz1E%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1511967770&oauth_token=token&oauth_version=1.0"], @"The generated OAuth signature should match the expected value.");
}

- (void)testInitSetsInstanceVariables {
    TMOAuth *tmOAuth = [[TMOAuth alloc] initWithURL:[NSURL URLWithString:@"https://tumblr.com/"] method:@"GET" postParameters:[NSDictionary dictionary] nonce:@"1234" consumerKey:@"consumerKey" consumerSecret:@"consumerSecret" token:@"token" tokenSecret:@"tokenSecret"];

    XCTAssertNotNil(tmOAuth.baseString, @"baseString is expected to have a value after initialization.");
    XCTAssertNotNil(tmOAuth.headerString, @"headerString is expected to have a value after initialization.");
}

@end
