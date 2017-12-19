//
//  TMURLSessionTests.swift
//  Orangina
//
//  Created by Kenny Ackerson on 5/24/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

import Foundation
import TMTumblrSDK
import XCTest

final class TMURLSessionTests: XCTestCase {
    
    let URLSessionManager = TMURLSession(configuration: URLSessionConfiguration.default, applicationCredentials: TMAPIApplicationCredentials(consumerKey: "kenny", consumerSecret: "paul"), userCredentials: TMAPIUserCredentials(token: "token'", tokenSecret: "ht"))

    static func baseURLString() -> String {
        return "https://api.tumblr.com/v2/"
    }

    let baseURL = URL(string: TMURLSessionTests.baseURLString())
    
    func testURLSessionManagerInvalidation() {
        let token = "watch"
        let tokenSecret = "triple"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: TMURLSessionInvalidateApplicationCredentialsNotificationKey), object: TMAPIUserCredentials(token: token, tokenSecret: tokenSecret))
        
        XCTAssert(URLSessionManager.canSignRequests())

        let HTTPHeaders = [
            "kenny": "is cool!",
            "try": "hi"
        ]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: TMURLSessionInvalidateHTTPHeadersNotificationKey), object: HTTPHeaders)

        let task = URLSessionManager.task(with: TMHTTPRequest.init(urlString: "http://google.com", method: .GET)) { (data, response, error) in

        }

        XCTAssert((task.currentRequest?.allHTTPHeaderFields) ?? [String: String]() == HTTPHeaders)

    }
    
    func testGETRequest() {
        let request = signedRequest(.GET, path: "config", parameters: nil)
        
        XCTAssertNotNil(request.allHTTPHeaderFields?["Authorization"], "An authorization header should be included in the signed request.")
        XCTAssert(request.url?.absoluteString == "https://api.tumblr.com/v2/config", "The URL of the request should consist of the base URL + the path.")
        XCTAssert(request.httpMethod == "GET", "A TMHTTPRequestMethodGET should result in a GET request.")
    }
    
    func testGETRequestParameters() {
        let path = "config"
        let parameters = ["key": "some value", "foo": "bar"]
        let request = signedRequest(.GET, path: path, parameters: parameters as [String : AnyObject]?)
        
        let urlString = TMURLSessionTests.baseURLString() + "/config?api_key=kenny&foo=bar&key=some%20value"

        XCTAssert(request.url == URL(string: urlString), "Parameters passed to a GET request should correctly pass then to the URL via NSURLComponents.")
    }
    
    func testPOSTRequest() {
        let request = signedRequest(.POST, path: "config", parameters: nil)
        
        XCTAssertNotNil(request.allHTTPHeaderFields?["Authorization"], "An authorization header should be included in the signed request.")
        XCTAssert(request.url?.absoluteString == "https://api.tumblr.com/v2/config", "The URL of the request should consist of the base URL + the path.")
        XCTAssert(request.httpMethod == "POST", "A TMHTTPRequestMethodPOST should result in a POST request.")
    }
    
    func testPOSTRequestBody() {
        let parameters = ["key": "some value", "foo": "bar"]
        let request = signedRequest(.POST, path: "config", parameters: parameters as [String : AnyObject]?)
        
        let data = "foo=bar&key=some%20value".data(using: String.Encoding.utf8, allowLossyConversion: false)
        XCTAssert(request.httpBody == data, "The body of the POST request should include all provided parameters.")
    }

    func testDELETERequest() {
        let request = signedRequest(.DELETE, path: "config", parameters: nil)
        
        XCTAssertNotNil(request.allHTTPHeaderFields?["Authorization"], "An authorization header should be included in the signed request.")
        XCTAssert(request.url?.absoluteString == "https://api.tumblr.com/v2/config", "The URL of the request should consist of the base URL + the path.")
        XCTAssert(request.httpMethod == "DELETE", "A TMHTTPRequestMethodDELETE should result in a DELETE request.")
    }
    
    func testDELETERequestParameters() {
        let path = "config"
        let parameters = ["key": "some value", "foo": "bar"]
        let request = signedRequest(.DELETE, path: path, parameters: parameters as [String : AnyObject]?)

        let urlString = TMURLSessionTests.baseURLString() + "/config?api_key=kenny&foo=bar&key=some%20value"
        XCTAssert(request.url == URL(string: urlString), "Parameters passed to a DELETE request should correctly be encoded in the URL.")
    }

    func testUploadTaskIsRightType() {
        let request = TMHTTPRequest(urlString: "http://tumblr.com", method: .POST, additionalHeaders: nil, requestBody: TMMultipartRequestBody(filePaths: [], contentTypes: [], fileNames: [], parameters: ["": ""], keys: [], encodeJSONBody: false), isSigned: true, isUpload: true)

        let task = URLSessionManager.task(with: request) { (data, response, error) in

        }

        XCTAssert(task is URLSessionUploadTask)
    }

    func testUploadTaskIsRightTypeWhenAddingIncrementalHandler () {
        let request = TMHTTPRequest(urlString: "http://tumblr.com", method: .POST, additionalHeaders: nil, requestBody: TMMultipartRequestBody(filePaths: [], contentTypes: [], fileNames: [], parameters: ["": ""], keys: [], encodeJSONBody: false), isSigned: true, isUpload: true)

        let task = URLSessionManager.task(with: request, incrementalHandler: { (data, task) in

            }, progressHandler: { (progress, task) in

        }) { (data, response, error) in
            
        }

        XCTAssert(task is URLSessionUploadTask)
    }

    func testUploadTaskIsRightTypeWhenAddingIncrementalHandlerAndNoBody () {
        let request = TMHTTPRequest(urlString: "http://tumblr.com", method: .POST, additionalHeaders: nil, requestBody: nil, isSigned: true, isUpload: true)

        let task = URLSessionManager.task(with: request, incrementalHandler: { (data, task) in

            }, progressHandler: { (progress, task) in

            }) { (data, response, error) in

        }

        XCTAssert(task is URLSessionUploadTask)
    }

    func testUploadTaskIsRightTypeWithNoBody () {
        let request = TMHTTPRequest(urlString: "http://tumblr.com", method: .POST, additionalHeaders: nil, requestBody: nil, isSigned: true, isUpload: true)

        let task = URLSessionManager.task(with: request) { (data, urlresponse, error) in
            
        }

        XCTAssert(task is URLSessionUploadTask)
    }

    func testCopyingWithConfiguration() {
        if let config = (URLSessionConfiguration.default.copy() as? URLSessionConfiguration) {
            config.httpAdditionalHeaders = ["h": "ello"]

            let request = TMHTTPRequest(urlString: "http://tumblr.com", method: .GET, additionalHeaders: nil, requestBody: nil, isSigned: true, isUpload: false)

            let task = URLSessionManager.copy(withNewConfiguration: config).task(with: request, incrementalHandler: { (data, task) in

            }, progressHandler: { (progress, task) in

            }, completionHandler: { (data, response, error) in

            })

            if let value = task.currentRequest?.allHTTPHeaderFields?["h"] {
                XCTAssert(value == "ello")
            }
            else {
                XCTFail()
            }

        }
        else {
            XCTFail()
        }

    }

    func testAdditionalHeadersWork() {
        let URLSessionManager = TMURLSession(configuration: URLSessionConfiguration.default, applicationCredentials: TMAPIApplicationCredentials(consumerKey: "kenny", consumerSecret: "paul"), userCredentials: TMAPIUserCredentials(token: "token", tokenSecret: "ht"), networkActivityManager: nil, sessionTaskUpdateDelegate: nil, sessionMetricsDelegate: nil, requestTransformer:nil, additionalHeaders: ["kenny": "ios"])

        let task = URLSessionManager.task(with: TMHTTPRequest(urlString: "https://tumblr.com", method: .GET), completionHandler: { (data, response, error) in

        })

        if let request = task.currentRequest,
            let value = request.allHTTPHeaderFields?["kenny"] {

            XCTAssert(value == "ios")
        }
        else {
            XCTFail()
        }

    }

    func testRequestTransformerCanUpdateHeaders() {
        class ExampleTransformer: TMRequestTransformer {
            func transform(_ request: TMRequest) -> TMRequest {
                return request.addingAdditionalHeaders(["tape": "tumblr"])
            }
        }

        let transformer = ExampleTransformer()

        let URLSessionManager = TMURLSession(configuration: URLSessionConfiguration.default,
                                             applicationCredentials: TMAPIApplicationCredentials(consumerKey: "kenny", consumerSecret: "paul"),
                                             userCredentials: TMAPIUserCredentials(token: "token", tokenSecret: "ht"),
                                             networkActivityManager: nil,
                                             sessionTaskUpdateDelegate: nil,
                                             sessionMetricsDelegate: nil,
                                             requestTransformer: transformer,
                                             additionalHeaders: nil)

        let task = URLSessionManager.task(with: TMHTTPRequest(urlString: "https://tumblr.com", method: .GET), completionHandler: { (data, response, error) in })

        guard let request = task.currentRequest, let headers = request.allHTTPHeaderFields else {
            XCTFail()
            return
        }

        XCTAssertEqual(headers, ["tape": "tumblr"])
    }

    // MARK: -
    
    fileprivate func signedRequest(_ method: TMHTTPRequestMethod, path: String, parameters: [String: AnyObject]?) -> URLRequest {
        guard let baseURL = baseURL else {
            return URLRequest(url: URL(fileURLWithPath: ""))
        }

        let APIRequest = TMAPIRequest(baseURL: baseURL,
                                      method: method,
                                      path: path,
                                      queryParameters: method == .GET || method == .DELETE ? parameters : nil,
                                      requestBody: method == .POST ? TMQueryEncodedRequestBody(queryDictionary: parameters ?? [String: AnyObject]()) : nil,
                                      additionalHeaders: nil)

        return URLSessionManager.paramaterizedRequest(from: APIRequest)
    }
}
