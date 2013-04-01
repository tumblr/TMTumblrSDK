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

- (void)testQueryToDictionary {
    NSDictionary *dictionary = TMQueryStringToDictionary(@"title=SomeTitle&body=SomeBody");
    dictionary = TMQueryStringToDictionary(@"title=SomeTitle&tag=lol&tag=gif");
}

- (void)testDictionaryToQuery {
    
}

@end
