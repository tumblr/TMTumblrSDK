//
//  TMRequestBodiesTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMQueryEncodedRequestBody.h>
#import <TMTumblrSDK/TMFormEncodedRequestBody.h>
#import <TMTumblrSDK/TMJSONEncodedRequestBody.h>
#import <TMTumblrSDK/TMGZIPEncodedRequestBody.h>
#import <zlib.h>

@interface TMRequestBodiesTests : XCTestCase

@end

@implementation TMRequestBodiesTests

- (void)testQueryParametersAreTheSame {
    TMQueryEncodedRequestBody *queryBody = [[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}];

    const BOOL passes = [queryBody.parameters isEqual:@{@"paul" : @"kenny", @"pool" : @"object"}];

    XCTAssert(passes);
}

- (void)testQueryContentTypeIsRightForQuery {
    TMQueryEncodedRequestBody *queryBody = [[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}];

    XCTAssert(queryBody.contentType == nil);
}

- (void)testQueryContentTypeIsRightForForm {
    TMFormEncodedRequestBody *body = [[TMFormEncodedRequestBody alloc] initWithBody:@{@"4" : @3}];

    XCTAssert([body.contentType isEqualToString:@"application/x-www-form-urlencoded; charset=utf-8"]);
}

- (void)testQueryContentTypeIsRightForJSON {
    TMJSONEncodedRequestBody *body = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];

    XCTAssert([body.contentType isEqualToString:@"application/json"]);
}

- (void)testQueryContentTypeIsRightForGzippedJSON {
    TMJSONEncodedRequestBody *jsonBody = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];
    TMGZIPEncodedRequestBody *body = [[TMGZIPEncodedRequestBody alloc] initWithRequestBody:jsonBody];

    XCTAssert([body.contentType isEqualToString:@"application/json"]);
}

- (void)testContentTypeIsNil {
    NSString *contentType = [[[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}] contentType];
    XCTAssertNil(contentType);
}

- (void)testDataExists {
    NSData *data = [[[TMQueryEncodedRequestBody alloc] initWithQueryDictionary:@{@"paul" : @"kenny", @"pool" : @"object"}] bodyData];

    XCTAssert(data);
}

- (void)testFormEncodedRequestBodysParamtersAreCorrect {
    TMFormEncodedRequestBody *body = [[TMFormEncodedRequestBody alloc] initWithBody:@{@"4" : @3}];
    XCTAssert([[body parameters] isEqual:@{@"4" : @3}]);
}

- (void)testJSONEncodedRequestBodysParamtersAreCorrect {
    TMJSONEncodedRequestBody *body = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];
    XCTAssert([[body parameters] isEqual:@{@"4" : @3}]);
}

- (void)testBodyIsRightForGzippedJSON {
    TMJSONEncodedRequestBody *jsonBody = [[TMJSONEncodedRequestBody alloc] initWithJSONDictionary:@{@"4" : @3}];
    TMGZIPEncodedRequestBody *body = [[TMGZIPEncodedRequestBody alloc] initWithRequestBody:jsonBody];

    XCTAssert([[self unZipTinyData:body.bodyData] isEqualToString:@"{\"4\":3}"],  @"Strings are not equal %@ %@", @"{\"4\":3}", [self unZipTinyData:body.bodyData]);
}

#pragma mark - Helpers
// tiny unzip functionality that can return up to 1k of unzipped data which is good enough for unit tests
- (NSString *)unZipTinyData:(NSData *)data {
    z_stream strm;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = (unsigned int)[data length];
    strm.next_in = (Bytef *)[data bytes];
    NSMutableData *uncompressed = [[NSMutableData alloc] initWithLength:1024];
    strm.avail_out = 1024;
    strm.next_out = [uncompressed mutableBytes];

    if (inflateInit2(&strm, MAX_WBITS | 16) != Z_OK) {
        return nil;
    }

    int z_error = inflate(&strm, Z_NO_FLUSH);

    if (z_error == Z_STREAM_END) {
        [uncompressed setLength:strm.total_out];
        return [[NSString alloc] initWithData:uncompressed encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

@end
