//
//  TMSDKFunctionsTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/11/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMSDKFunctions.h> 

@interface TMSDKFunctionsTests : XCTestCase

@end

@implementation TMSDKFunctionsTests

- (void)testDecodeDoesntChangeStringThatDoesntNeedToBe {

    NSString *URL = @"https://api.tumblr.com/v2/user/info";

    XCTAssert([TMURLDecode(URL) isEqualToString:URL]);
}

- (void)testDecodePlusSignDecodesIntoSpace {

    NSString *URL = @"https://api.tumblr.com/v2/user/info?user=pear+apps";

    XCTAssert([TMURLDecode(URL) isEqualToString:@"https://api.tumblr.com/v2/user/info?user=pear apps"]);
}

- (void)testPercentTwentyDecodesIntoSpace {
    NSString *URL = @"https://api.tumblr.com/v2/user/info?user=pear%20apps";

    XCTAssert([TMURLDecode(URL) isEqualToString:@"https://api.tumblr.com/v2/user/info?user=pear apps"]);
}

- (void)testNonStringEncode{
    id object = @3;

    XCTAssert([TMURLEncode(object) isEqual:@"3"]);
}

- (void)testQueryStringToDictionary {
    NSDictionary *dictionary = TMQueryStringToDictionary(@"user=ello&me=kenny");

    XCTAssert([dictionary[@"user"] isEqualToString:@"ello"]);
    XCTAssert([dictionary[@"me"] isEqualToString:@"kenny"]);
}

- (void)testQueryStringToDictionaryWithArrayInside {
    NSDictionary *dictionary = TMQueryStringToDictionary(@"user=ello&me=kenny&me=paul");

    XCTAssert([dictionary[@"user"] isEqualToString:@"ello"]);

    const BOOL arrayExists = [dictionary[@"me"] isEqual:@[@"kenny", @"paul"]];

    XCTAssert(arrayExists);
}

- (void)testQueryStringToDictionaryWithArrayOfMultipleObjectsInside {
    NSDictionary *dictionary = TMQueryStringToDictionary(@"user=ello&me=kenny&me=paul&me=ken");

    XCTAssert([dictionary[@"user"] isEqualToString:@"ello"]);

    const BOOL arrayExists = [dictionary[@"me"] isEqual:@[@"kenny", @"paul", @"ken"]];

    XCTAssert(arrayExists);
}

- (void)testDictionaryToQueryStringWorks {
    NSString *queryString = TMDictionaryToQueryString(@{@"kenny" : @"hello"});
    XCTAssert([queryString isEqualToString:@"kenny=hello"]);
}

- (void)testDictionaryToQueryStringWorksWithArray {
    NSString *queryString = TMDictionaryToQueryString(@{@"kenny" : @"hello", @"other" : @[@"okay", @"alright"]});
    XCTAssert([queryString isEqualToString:@"kenny=hello&other=okay&other=alright"]);
}

- (void)testDictionaryToQueryStringWorksWithArrayOfMultipleObjects {
    NSString *queryString = TMDictionaryToQueryString(@{@"kenny" : @"hello", @"other" : @[@"okay", @"alright", @"ello"]});
    XCTAssert([queryString isEqualToString:@"kenny=hello&other=okay&other=alright&other=ello"]);
}

- (void)testDictionaryToQueryStringWorksWithDictionary {
    NSString *queryString = TMDictionaryToQueryString(@{@"kenny" : @"hello", @"other" : @{@"okay" : @"alright"}});
    XCTAssert([queryString isEqualToString:@"kenny=hello&other%5Bokay%5D=alright"]);
}

@end
