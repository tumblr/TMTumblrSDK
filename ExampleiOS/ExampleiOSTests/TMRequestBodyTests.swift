//
//  TMRequestBodyTests.swift
//  ExampleiOS
//
//  Created by Noah Hilt on 3/14/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

import TMTumblrSDK
import XCTest

final class TMRequestBodyTests: XCTestCase {
    func testFormEncodedBody() {
        let dictionary = testDictionary()
        let requestBody = TMFormEncodedRequestBody(body: dictionary)
        XCTAssertEqual(requestBody.parameters() as NSDictionary, dictionary as NSDictionary, "Form encoded request parameters should equal the body dictionary passed in.")
        XCTAssertTrue(requestBody.encodeParameters(), "Form encoded request body should encode parameters.")
    }

    func testJSONRequestBody() {
        let dictionary = testDictionary()
        let requestBody = TMJSONEncodedRequestBody(jsonDictionary: dictionary)
        XCTAssertEqual(requestBody.parameters() as NSDictionary, dictionary as NSDictionary, "JSON request parameters should equal the JSON dictionary passed in.")
        XCTAssertFalse(requestBody.encodeParameters(), "JSON request body should not encode parameters.")
    }

    func testQueryEncodedBody() {
        let dictionary = testDictionary()
        let requestBody = TMQueryEncodedRequestBody(queryDictionary: dictionary)
        XCTAssertEqual(requestBody.parameters() as NSDictionary, dictionary as NSDictionary, "Query encoded request parameters should equal the query dictionary passed in.")
        XCTAssertTrue(requestBody.encodeParameters(), "Query encoded request body should encode parameters.")
    }

    func testJSONRequestContentType() {
        let dictionary = testDictionary()
        let requestBody = TMJSONEncodedRequestBody(jsonDictionary: dictionary)
        XCTAssertEqual(requestBody.contentType() as String?, "application/json", "JSON request should have Content-Type: application/json.")
    }

    func testJSONRequestContentEncoding() {
        let dictionary = testDictionary()
        let requestBody = TMJSONEncodedRequestBody(jsonDictionary: dictionary)
        XCTAssertEqual(requestBody.contentEncoding() as String?, nil, "JSON request should NOT have a Content-Encoding.")
    }

    func testGZIPJSONRequestContentType() {
        let dictionary = testDictionary()
        let requestBody = TMGZIPEncodedRequestBody(requestBody: TMJSONEncodedRequestBody(jsonDictionary: dictionary))
        XCTAssertEqual(requestBody.contentType() as String?, "application/json", "GZipped JSON request should have Content-Type: application/json.")
    }

    func testGZIPJSONRequestContentEncoding() {
        let dictionary = testDictionary()
        let requestBody = TMGZIPEncodedRequestBody(requestBody: TMJSONEncodedRequestBody(jsonDictionary: dictionary))
        XCTAssertEqual(requestBody.contentEncoding() as String?, "gzip", "GZipped JSON request should have Content-Encoding: gzip.")
    }

    // MARK: Private

    private func testDictionary() -> [AnyHashable: Any] {
        return ["testing": [1,2,3]]
    }
}
