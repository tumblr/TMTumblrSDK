//
//  TMAPIApplicationCredentialsTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMAPIApplicationCredentials.h>

@interface TMAPIApplicationCredentialsTests : XCTestCase

@end

@implementation TMAPIApplicationCredentialsTests

- (void)testEmptyStringsAreNotValid {
    TMAPIApplicationCredentials *credentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@""];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testKeyEmptyStringIsNotValid {
    TMAPIApplicationCredentials *credentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"dsaf" consumerSecret:@""];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testConsumerKeyEmptyStringIsNotValid {
    TMAPIApplicationCredentials *credentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@"dasfa"];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testFullKeyAndSecreteIsValid {
    TMAPIApplicationCredentials *credentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"sadfas" consumerSecret:@"dasfa"];
    XCTAssert(credentials.validCredentials);
}

@end
