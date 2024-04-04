//
//  TMAPIUserCredentialsTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/10/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMAPIUserCredentials.h"

@interface TMAPIUserCredentialsTests : XCTestCase

@end

@implementation TMAPIUserCredentialsTests

- (void)testEmptyStringsAreNotValid {
    TMAPIUserCredentials *credentials = [[TMAPIUserCredentials alloc] initWithToken:@"" tokenSecret:@""];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testKeyEmptyStringIsNotValid {
    TMAPIUserCredentials *credentials = [[TMAPIUserCredentials alloc] initWithToken:@"dasfd" tokenSecret:@""];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testConsumerKeyEmptyStringIsNotValid {
    TMAPIUserCredentials *credentials = [[TMAPIUserCredentials alloc] initWithToken:@"" tokenSecret:@"dasda"];
    XCTAssertFalse(credentials.validCredentials);
}

- (void)testFullKeyAndSecreteIsValid {
    TMAPIUserCredentials *credentials = [[TMAPIUserCredentials alloc] initWithToken:@"dsafsa" tokenSecret:@"dasfd"];
    XCTAssert(credentials.validCredentials);
}

@end
