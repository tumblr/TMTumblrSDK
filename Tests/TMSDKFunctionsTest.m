//
//  TMSDKFunctionsTest.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/31/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMSDKFunctions.h"

@interface TMSDKFunctionsTest : XCTestCase

@end


@implementation TMSDKFunctionsTest

- (void)testQueryToDictionaryWithTwoParameters {
    NSString *title = @"Some title";
    NSString *body = @"LOL";
    
    NSDictionary *dictionary = TMQueryStringToDictionary([NSString stringWithFormat:@"title=%@&body=%@",
                                                          TMURLEncode(title), TMURLEncode(body)]);
    
    XCTAssertTrue([[dictionary allKeys] count] == 2, @"Incorrect number of dictionary keys");
    XCTAssertEqualObjects(dictionary[@"title"], title, @"Title parameter is incorrect");
    XCTAssertEqualObjects(dictionary[@"body"], body, @"Body parameter is incorrect");
}

- (void)testQueryToDictionaryWithRepeatedParameter {
    NSString *title = @"Title";
    NSString *tag1 = @"l  o  l";
    NSString *tag2 = @"gi://$@DAISDJ++++DSADf";
    NSString *tag3 = @"foo=bar&baz+foo2";

    NSDictionary *dictionary = TMQueryStringToDictionary([NSString stringWithFormat:@"title=%@&tag=%@&tag=%@&tag=%@",
                                                          TMURLEncode(title), TMURLEncode(tag1), TMURLEncode(tag2),
                                                          TMURLEncode(tag3)]);

    NSArray *tags = @[tag1, tag2, tag3];
    
    XCTAssertTrue([[dictionary allKeys] count] == 2, @"Incorrect number of dictionary keys");
    XCTAssertEqualObjects(dictionary[@"title"], title, @"Title parameter is incorrect");
    XCTAssertEqualObjects(dictionary[@"tag"], tags, @"Tag parameter is incorrect");
}

- (void)testDictionaryToQueryWithTwoParameters {
    NSString *title = @"Some $$$@#?@#9i==%&&&&title";
    NSString *body = @"Some \n\n===+   body";
    
    NSString *result = [NSString stringWithFormat:@"body=%@&title=%@", TMURLEncode(body), TMURLEncode(title)];
    
    XCTAssertEqualObjects(TMDictionaryToQueryString(@{ @"title" : title, @"body" : body }), result,
                         @"Incorrect query string");
}

- (void)testDictionaryToQueryWithRepeatedParameter {
    NSString *title = @"Some $$$@#?@#9i==%&&&&title";
    NSArray *tags = @[@"adioj ASD $**$*$ a8aA//&&adsijd====", @"lol", @"    foo bar baz    "];
    
    NSString *result = [NSString stringWithFormat:@"tag=%@&tag=%@&tag=%@&title=%@", TMURLEncode(tags[0]),
                        TMURLEncode(tags[1]), TMURLEncode(tags[2]), TMURLEncode(title)];
    
    XCTAssertEqualObjects(TMDictionaryToQueryString(@{ @"title" : title, @"tag" : tags }), result,
                         @"Incorrect query string with repeated parameter");
}

- (void)testDictionaryToQueryWithNestedDictionary {
    NSDictionary *input = @{
                            @"stringKey": @"value",
                            @"arrayKey": @[@"arrayValue1", @"arrayValue2"],
                            @"dictionaryKey": @{
                                    @"innerDictionaryKey1": @"innerDictionaryValue1",
                                    @"innerDictionaryKey2": @"innerDictionaryValue2"
                                    },
                            };
    
    NSString *expected = [NSString stringWithFormat:@"arrayKey=arrayValue1&arrayKey=arrayValue2&%@=innerDictionaryValue1&%@=innerDictionaryValue2&stringKey=value",
                          TMURLEncode(@"dictionaryKey[innerDictionaryKey1]"),
                          TMURLEncode(@"dictionaryKey[innerDictionaryKey2]")];
    
    NSString *actual = TMDictionaryToQueryString(input);
    
    XCTAssertEqualObjects(expected, actual);
}

@end
