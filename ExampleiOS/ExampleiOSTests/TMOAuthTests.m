//
//  TMOAuthTests.m
//  ExampleiOSTests
//
//  Created by dave on 11/28/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMOAuth.h"

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

- (void)testSignUrlWithQueryWithArrayParams {
    NSURL *signedURL = [TMOAuth signUrlWithQueryComponent:[NSURL URLWithString:@"https://tumblr.com/?rollups=true&types[0]=like&types[1]=follow&types[10]=post_appeal_accepted&types[11]=mention_in_reply&types[12]=ask&types[13]=reblog_naked&types[14]=post_appeal_rejected&types[15]=reply&types[2]=answered_ask&types[3]=new_group_blog_member&types[4]=post_attribution&types[5]=reblog_with_content&types[6]=post_flagged&types[7]=what_you_missed&types[8]=mention_in_post&types[9]=conversational_note"]
                                                   method:@"GET"
                                           postParameters:[NSDictionary dictionary]
                                                    nonce:@"1234"
                                              consumerKey:@"consumerKey"
                                           consumerSecret:@"consumerSecret"
                                                    token:@"token"
                                              tokenSecret:@"tokenSecret"
                                                timestamp:@"1511967770"];
    XCTAssert([signedURL.absoluteString isEqualToString:@"https://tumblr.com/?rollups=true&types%5B0%5D=like&types%5B1%5D=follow&types%5B10%5D=post_appeal_accepted&types%5B11%5D=mention_in_reply&types%5B12%5D=ask&types%5B13%5D=reblog_naked&types%5B14%5D=post_appeal_rejected&types%5B15%5D=reply&types%5B2%5D=answered_ask&types%5B3%5D=new_group_blog_member&types%5B4%5D=post_attribution&types%5B5%5D=reblog_with_content&types%5B6%5D=post_flagged&types%5B7%5D=what_you_missed&types%5B8%5D=mention_in_post&types%5B9%5D=conversational_note?oauth_consumer_key=consumerKey&oauth_nonce=1234&oauth_signature=Kn9oxNY8jR5crhBPjn10pXmsm/k%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1511967770&oauth_token=token&oauth_version=1.0"],
              @"The generated OAuth signature should match the expected value.");
}

- (void)testInitSetsInstanceVariables {
    TMOAuth *tmOAuth = [[TMOAuth alloc] initWithURL:[NSURL URLWithString:@"https://tumblr.com/"] method:@"GET" postParameters:[NSDictionary dictionary] nonce:@"1234" consumerKey:@"consumerKey" consumerSecret:@"consumerSecret" token:@"token" tokenSecret:@"tokenSecret"];

    XCTAssertNotNil(tmOAuth.baseString, @"baseString is expected to have a value after initialization.");
    XCTAssertNotNil(tmOAuth.headerString, @"headerString is expected to have a value after initialization.");
}

@end
