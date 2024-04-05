//
//  TMResponseParserTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 4/27/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMResponseParserTests : XCTestCase

@end

@implementation TMResponseParserTests

- (void)testInvalidURLResponseProducesCorrectError {
    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[[NSData alloc] init]
                                                                  URLResponse:[[NSURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert(!response.JSONDictionary);
    XCTAssert(!response.successful);
    XCTAssert(response.error.code == TMHTTPResponseErrorCodeWrongResponseType);
    XCTAssert(response.responseDescription);
    XCTAssert(response.statusCode == 0);
}

- (void)testInvalidURLResponseProducesCorrectErrorIfErrorAlreadyExists {
    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[[NSData alloc] init]
                                                                  URLResponse:[[NSURLResponse alloc] init]
                                                                        error:[[NSError alloc] initWithDomain:@"com.fake.error" code:233 userInfo:nil]
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert(!response.JSONDictionary);
    XCTAssert(!response.successful);
    XCTAssert(response.error.code == 233);
    XCTAssert(response.responseDescription);
    XCTAssert(response.statusCode == 0);
}

- (void)testValidJSONGetsParsedCorrectly {
    NSDictionary *test = [self testJSON];

    NSData *data = [self dataForJSONObject:@{@"response" : test}];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:data
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:test]);
}

- (void)testValidJSONArrayGetsParsedCorrectly {
    NSArray *test = [self testJSONArray];

    NSData *data = [self dataForJSONObject:@{@"response" : test}];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:data
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONArray isEqual:test]);
    XCTAssert(response.JSONDictionary.count == 0);
}


- (void)testValidJSONGetsCorrectStatusCodeBackAndJSONIsCorrect {
    for (NSNumber *statusCode in @[@200, @201]) {
        for (NSDictionary *JSON in @[[self testJSON], [self testJSONNested]]) {
            TMParsedHTTPResponse *response = [self runTestForValidJSONWithStatusCode:JSON statusCode:statusCode.integerValue];
            XCTAssert(response.successful);
            XCTAssert(!response.error);
        }
    }
}

- (void)testValidJSONGetsCorrectStatusCodeBackAndJSONIsCorrectOnFailures {
    for (NSNumber *statusCode in @[@400, @401, @403, @404, @405, @428, @429, @500, @504]) {
        for (NSDictionary *JSON in @[[self testJSON], [self testJSONNested]]) {
            TMParsedHTTPResponse *response = [self runTestForValidJSONWithStatusCode:JSON statusCode:statusCode.integerValue];
            XCTAssert(!response.successful);

            /**
             *  Welp, we do need errors for bad codes!
             */
            XCTAssert(response.error);
        }
    }
}

- (void)testNonJSONDataReturnsEmptyJSONDictionary {
    int *bytes = malloc(sizeof(int) * 2);
    bytes[0] = 1;
    bytes[1] = 0;

    NSData *nonJSONData = [[NSData alloc] initWithBytes:bytes length:sizeof(int) * 2];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:nonJSONData
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:@{}]);

    free(bytes);
}

- (void)testPassingNoToSerializeJSONReturnsEmptyJSONDictionary {

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:[self testJSON]]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:NO];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:@{}]);
}

- (void)testPassingANonResponseKeyHavingDictionaryReturnsAnEmptyDictionary {

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"Bad": @"response"}]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:NO];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:@{}]);
}

- (void)testPassingAnInvalidTypeForResponseReturnsEmptyDictionary {

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@[@"wrong", @"type", @"of", @"response!"]]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:NO];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:@{}]);
}

- (void)testPassingAnInvalidTypeForResponseKeyReturnsEmptyDictionary {

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @[@"wrong", @"type", @"of", @"response!"] }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:NO];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:@{}]);
}

#pragma mark Private Helpers -

- (TMParsedHTTPResponse *)runTestForValidJSONWithStatusCode:(NSDictionary *)dictionary statusCode:(NSInteger)statusCode {

    NSData *data = [self dataForJSONObject:@{@"response" : dictionary}];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:data
                                                                  URLResponse:[[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"http://tumblr.com"]
                                                                                                          statusCode:statusCode
                                                                                                         HTTPVersion:@"HTTP/1.1"
                                                                                                        headerFields:nil]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMParsedHTTPResponse *response = [responseParser parse];

    XCTAssert([response.JSONDictionary isEqual:dictionary]);
    XCTAssert(response.statusCode == statusCode);
    XCTAssert(response.responseDescription);

    return response;
}

- (NSDictionary *)testJSON {
    return @{@"hello" : @"chains", @"I'm" : @"kenny", @"key" : @45};
}

- (NSDictionary *)testJSONNested {
    return @{
             @"key": @{
                     @"hello" : @"to you",
                     @"otherKey" : [self testJSON]
                 }
             };
}

- (NSArray *)testJSONArray {
    return @[
        @{ @"key" : @"value1" },
        @{ @"key" : @"value2" }
    ];
}

- (NSData *)dataForJSONObject:(id)JSONObject {
    return [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:nil];
}

@end
