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
    NSString *signedURL = [TMOAuth signUrlWithQueryComponent:[NSURL URLWithString:@"https://tumblr.com/"]
                                                      method:@"GET"
                                              postParameters:[NSDictionary dictionary]
                                                       nonce:@"1234"
                                                 consumerKey:@"consumerKey"
                                              consumerSecret:@"consumerSecret"
                                                       token:@"token"
                                                 tokenSecret:@"tokenSecret"
                                                   timestamp:@"1511967770"];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:signedURL];
    NSArray *queryItems = urlComponents.queryItems;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", @"oauth_signature"];
    NSURLQueryItem *queryItem = [queryItems filteredArrayUsingPredicate:predicate].firstObject;
    
    XCTAssert([queryItem.value isEqualToString:@"w/LP1MdJwiCfakR3GbW9IoeOz1E="], @"The generated OAuth signature should match the expected value.");
}

- (void)testInitSetsInstanceVariables {
    TMOAuth *tmOAuth = [[TMOAuth alloc] initWithURL:[NSURL URLWithString:@"https://tumblr.com/"] method:@"GET" postParameters:[NSDictionary dictionary] nonce:@"1234" consumerKey:@"consumerKey" consumerSecret:@"consumerSecret" token:@"token" tokenSecret:@"tokenSecret"];

    XCTAssertNotNil(tmOAuth.baseString, @"baseString is expected to have a value after initialization.");
    XCTAssertNotNil(tmOAuth.headerString, @"headerString is expected to have a value after initialization.");
}

@end
