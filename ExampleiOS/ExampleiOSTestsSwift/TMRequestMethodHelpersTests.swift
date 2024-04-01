//
//  TMRequestMethodHelpersTests.swift
//  ExampleiOS
//
//  Created by Kenny Ackerson on 10/18/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

import TMTumblrSDK
import XCTest

final class TMRequestMethodHelpersTests: XCTestCase {
    
    func testDeleteEnumIsDeleteString() {
        let result = TMRequestMethodHelpers.string(from: .DELETE)
        XCTAssert(result == "DELETE", "The .DELETE enum case should always produce the DELETE string")
    }

    func testGetEnumIsGetString() {
        let result = TMRequestMethodHelpers.string(from: .GET)
        XCTAssert(result == "GET", "The .GET enum case should always produce the GET string")
    }

    func testPOSTEnumIsPostString() {
        let result = TMRequestMethodHelpers.string(from: .POST)
        XCTAssert(result == "POST", "The .POST enum case should always produce the POST string")
    }

    func testPUTEnumIsPutString() {
        let result = TMRequestMethodHelpers.string(from: .PUT)
        XCTAssert(result == "PUT", "The .POST enum case should always produce the POST string")
    }

    func testHEADEnumIsHeadString() {
        let result = TMRequestMethodHelpers.string(from: .HEAD)
        XCTAssert(result == "HEAD", "The .POST enum case should always produce the POST string")
    }

    func testPUTEnumIsPut() {
        let result = TMRequestMethodHelpers.method(from: "PUT")
        XCTAssert(result == .PUT)
    }

    func testHEADEnumIsHead() {
        let result = TMRequestMethodHelpers.method(from: "HEAD")
        XCTAssert(result == .HEAD)
    }
}
