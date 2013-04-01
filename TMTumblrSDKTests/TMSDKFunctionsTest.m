//
//  TMSDKFunctionsTest.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/31/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMSDKFunctionsTest.h"

#import "TMSDKFunctions.h"

@implementation TMSDKFunctionsTest

- (void)testQueryToDictionaryWithTwoParameters {
    NSString *title = @"Some title";
    NSString *body = @"LOL";
    
    NSDictionary *dictionary = TMQueryStringToDictionary([NSString stringWithFormat:@"title=%@&body=%@",
                                                          TMURLEncode(title), TMURLEncode(body)]);
    
    STAssertTrue([[dictionary allKeys] count] == 2, @"Incorrect number of dictionary keys");
    STAssertEqualObjects(dictionary[@"title"], title, @"Title parameter is incorrect");
    STAssertEqualObjects(dictionary[@"body"], body, @"Body parameter is incorrect");
}

- (void)testQueryToDictionaryWithRepeatedParameter {
    NSString *title = @"Title";
    NSString *tag1 = @"l  o  l";
    NSString *tag2 = @"gi://$@DAISDJ++++DSADf";
    NSString *tag3 = @"foo=bar&baz+foo2";

    NSDictionary *dictionary = TMQueryStringToDictionary([NSString stringWithFormat:@"title=%@&tag=%@&tag=%@&tag=%@",
                                                          TMURLEncode(title), TMURLEncode(tag1), TMURLEncode(tag2), TMURLEncode(tag3)]);

    NSArray *tags = @[tag1, tag2, tag3];
    
    STAssertTrue([[dictionary allKeys] count] == 2, @"Incorrect number of dictionary keys");
    STAssertEqualObjects(dictionary[@"title"], title, @"Title parameter is incorrect");
    STAssertEqualObjects(dictionary[@"tag"], tags, @"Tag parameter is incorrect");
}

- (void)testDictionaryToQueryWithTwoParameters {

}

- (void)testDictionaryToQueryWithRepeatedParameter {
    
}

@end
