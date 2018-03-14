//
//  TMXAuthAuthenticatorTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/14/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMXAuthAuthenticator.h>
#import <TMTumblrSDK/TMURLSession.h>

@interface TMXAuthAuthenticatorTests : XCTestCase

@end

@implementation TMXAuthAuthenticatorTests

- (void)testSessionTaskIsADataTask {

    TMXAuthAuthenticator *authenticator = [[TMXAuthAuthenticator alloc] initWithSession:[[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"hello" consumerSecret:@"tokensecret"] userCredentials:nil]];


    NSURLSessionTask *task = [authenticator xAuth:@"testemail@email.com" password:@"testpass" callback:^(TMAPIUserCredentials * _Nullable creds, id <TMAPIError> apiError, NSError * networkingError) {

    }];

    XCTAssert([task isKindOfClass:[NSURLSessionDataTask class]], "Unexpected return value type");
}

- (void)testSessionTaskIsADataTaskWithAuthToken {

    TMXAuthAuthenticator *authenticator = [[TMXAuthAuthenticator alloc] initWithSession:[[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"hello" consumerSecret:@"tokensecret"] userCredentials:nil]];


    NSURLSessionTask *task = [authenticator xAuth:@"testemail@email.com" password:@"testpass" authToken:@"token" gdprConsentResponseFields:nil gdprToken:nil callback:^(TMAPIUserCredentials * _Nullable creds, id <TMAPIError> apiError, NSError * networkingError) {

    }];

    XCTAssert([task isKindOfClass:[NSURLSessionDataTask class]], "Unexpected return value type");
}


@end
