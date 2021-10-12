//
//  TMOAuthAuthenticatorTests.m
//  ExampleiOS
//
//  Created by Tyler Tape on 4/12/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMMockSession.h"
#import "TMSynchronousMockURLSessionTask.h"
@import TMTumblrSDK;

NSString * const urlScheme = @"ello";
NSString * const authorizeURLString = @"https://www.tumblr.com/oauth/request_token?oauth_callback=ello%3A%2F%2Ftumblr-authorize";
NSString * const accessTokenURLString = @"https://www.tumblr.com/api/v2/oauth2/token";

@interface TMOAuthAuthenticatorTests : XCTestCase <TMOAuthAuthenticatorDelegate>

@property (nonatomic) NSURL *openedURL;
@property (nonatomic) BOOL completionCalled;

@end

@implementation TMOAuthAuthenticatorTests

- (void)setUp {
    [super setUp];
    self.openedURL = nil;
    self.completionCalled = NO;
}

- (void)testWhenAuthIsCalledErrorsArePassedThroughOnRequestFailure {
    TMSynchronousMockURLSessionTask *task = [self taskWithFakeResponse:@"error :(" statusCode:400];

    NSDictionary *dictionary = @{authorizeURLString: task};

    TMMockSession *session = [[TMMockSession alloc] initWithMockTaskDictionary:dictionary];

    TMOAuthAuthenticator *authenticator = [[TMOAuthAuthenticator alloc] initWithSession:session applicationCredentials:[self creds] delegate:self];

    [authenticator authenticate:urlScheme callback:^(TMAPIUserCredentials *creds, id <TMAPIError> apiError, NSError * networkingError) {
        XCTAssertNotNil(networkingError, @"An error should be passed in the case of failure");
        self.completionCalled = YES;
    }];

    XCTAssertTrue(self.completionCalled, @"The completion block was never called - test assertions not executed.");
}

- (void)testWhenAuthIsCalledTheDelegateIsPassedAUrlOnSuccess {
    TMSynchronousMockURLSessionTask *task = [self taskWithFakeResponse:@"oauth_token_secret=hi&oauth_token=hello" statusCode:200];

    NSDictionary *dictionary = @{authorizeURLString: task};

    TMMockSession *session = [[TMMockSession alloc] initWithMockTaskDictionary:dictionary];

    TMOAuthAuthenticator *authenticator = [[TMOAuthAuthenticator alloc] initWithSession:session applicationCredentials:[self creds] delegate:self];

    [authenticator authenticate:urlScheme callback:nil];

    XCTAssertEqualObjects(self.openedURL.absoluteString, @"https://www.tumblr.com/oauth/authorize?oauth_token=hello", @"Auth URL malformed or not passed to delegate");
}

- (void)testHandleOpenUrlFailsIfTheURLHostIsNotTheExpectedFormat {
    TMMockSession *session = [[TMMockSession alloc] initWithMockTaskDictionary:@{}];

    TMOAuthAuthenticator *authenticator = [[TMOAuthAuthenticator alloc] initWithSession:session applicationCredentials:[self creds] delegate:self];

    XCTAssertFalse([authenticator handleOpenURL:[NSURL URLWithString:@"https://tumblr-oatherize.com/"]], @"handleOpenURL should fail, returning NO");
}

- (void)testValidUserCredsArePassedThroughOnSuccess {
    TMSynchronousMockURLSessionTask *authTask = [self taskWithFakeResponse:@"oauth_token_secret=hi&oauth_token=hello" statusCode:200];
    TMSynchronousMockURLSessionTask *handleOpenURLTask = [self taskWithFakeResponse:@"oauth_token_secret=hey&oauth_token=whatsup" statusCode:200];

    TMMockSession *session = [[TMMockSession alloc] initWithMockTaskDictionary:@{authorizeURLString: authTask,
                                                                                 accessTokenURLString: handleOpenURLTask}];

    TMOAuthAuthenticator *authenticator = [[TMOAuthAuthenticator alloc] initWithSession:session applicationCredentials:[self creds] delegate:self];

    [authenticator authenticate:urlScheme callback:^(TMAPIUserCredentials *creds, id <TMAPIError> apiError, NSError * networkingError) {
        XCTAssertNil(networkingError, @"No error should be passed in the case of success");
        XCTAssertEqualObjects(creds.tokenSecret, @"hey", @"A valid token secret should be returned");
        XCTAssertEqualObjects(creds.token, @"whatsup", @"A valid token should be returned");
        self.completionCalled = YES;
    }];

    [authenticator handleOpenURL:[NSURL URLWithString:@"ello://tumblr-authorize?oauth_token=iliketurtles&oauth_verifier=immediateandsustained#_=_"]];

    XCTAssertTrue(self.completionCalled, @"The completion block was never called - test assertions not executed.");
}

- (void)testWhenTheSecondRequestFailsTheAuthCallbackIsCalledWithAnError {
    TMSynchronousMockURLSessionTask *authTask = [self taskWithFakeResponse:@"oauth_token_secret=hi&oauth_token=hello" statusCode:200];
    TMSynchronousMockURLSessionTask *handleOpenURLTask = [self taskWithFakeResponse:@"error :(" statusCode:401];

    TMMockSession *session = [[TMMockSession alloc] initWithMockTaskDictionary:@{authorizeURLString: authTask,
                                                                                 accessTokenURLString: handleOpenURLTask}];

    TMOAuthAuthenticator *authenticator = [[TMOAuthAuthenticator alloc] initWithSession:session applicationCredentials:[self creds] delegate:self];

    [authenticator authenticate:@"ello" callback:^(TMAPIUserCredentials *creds, id <TMAPIError> apiError, NSError * networkingError) {
        XCTAssertNotNil(networkingError, @"An error should be passed in the case of failure");
        XCTAssertNil(creds, @"No creds should be passed in the case of failure");
        self.completionCalled = YES;
    }];

    [authenticator handleOpenURL:[NSURL URLWithString:@"ello://tumblr-authorize?oauth_token=iliketurtles&oauth_verifier=immediateandsustained#_=_"]];

    XCTAssertTrue(self.completionCalled, @"The completion block was never called - test assertions not executed.");
}

#pragma mark - TMOAuthAuthenticatorDelegate

- (void)openURLInBrowser:(NSURL *)url {
    self.openedURL = url;
}

#pragma mark - Private

- (TMAPIApplicationCredentials *)creds {
    return [[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"key123" consumerSecret:@"secret!hello!"];
}

- (TMSynchronousMockURLSessionTask *)taskWithFakeResponse:(NSString *)responseContent statusCode:(NSInteger)code {
    return [[TMSynchronousMockURLSessionTask alloc]
                                             initWithDummyData:[responseContent dataUsingEncoding:NSUTF8StringEncoding]
                                             dummyResponse:[[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] init] statusCode:code HTTPVersion:@"1.1" headerFields:nil]
                                             dummyError:nil];
}

@end
