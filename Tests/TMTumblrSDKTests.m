//
//  TMTumblrSDKTests.m
//  Tumblr SDK
//
//  Created by Bryan Irace on 8/23/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMTumblrSDKTests.h"

#import "TMAPIClient.h"

@interface TMTumblrSDKTests()

@property (nonatomic, copy) TMAPISuccessCallback defaultSuccessCallback;
@property (nonatomic, copy) TMAPIErrorCallback defaultErrorCallback;
@property (nonatomic, assign) BOOL receivedAsynchronousCallback;

- (void)performAsynchronousTest:(void(^)(void))testCode;

@end

@implementation TMTumblrSDKTests

#pragma mark - Tests

- (void)testBlogInfo {
    [self performAsynchronousTest:^ {
        [[TMAPIClient sharedInstance] blogInfo:@"bryan" success:self.defaultSuccessCallback
                                         error:self.defaultErrorCallback];
    }];
}

- (void)testFollowers {
    [self performAsynchronousTest:^ {
        [[TMAPIClient sharedInstance] followers:@"bryan" limit:20 offset:0
                                        success:self.defaultSuccessCallback
                                          error:self.defaultErrorCallback];
    }];
}

#pragma mark - Common

- (void)setUp {
    [super setUp];
    
    self.defaultSuccessCallback = ^ (NSDictionary *result) {
        STAssertEquals([result[@"meta"][@"status"] intValue], 200, @"Response status code must be 200");
        STAssertNotNil(result[@"response"], @"Response body cannot be nil");
        
        self.receivedAsynchronousCallback = YES;
    };
    
    self.defaultErrorCallback = ^ (NSError *error, NSArray *validationErrors) {
        STFail(@"Request failed");
        
        self.receivedAsynchronousCallback = YES;
    };    
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        NSDictionary *credentials = [[NSDictionary alloc] initWithContentsOfFile:
                                     [[NSBundle bundleForClass:[TMTumblrSDKTests class]] pathForResource:@"Credentials"
                                                                                                  ofType:@"plist"]];
        
        NSString *APIKey = credentials[@"APIKey"];
        NSString *OAuthConsumerKey = credentials[@"OAuthConsumerKey"];
        NSString *OAuthConsumerSecret = credentials[@"OAuthConsumerSecret"];
        NSString *OAuthToken = credentials[@"OAuthToken"];
        NSString *OAuthTokenSecret = credentials[@"OAuthTokenSecret"];
        
        STAssertTrue(APIKey.length, @"APIKey required in Credentials.plist");
        STAssertTrue(OAuthConsumerKey.length, @"OAuthConsumerKey required in Credentials.plist");
        STAssertTrue(OAuthConsumerSecret.length, @"OAuthConsumerSecret required in Credentials.plist");
        STAssertTrue(OAuthToken.length, @"OAuthToken required in Credentials.plist");
        STAssertTrue(OAuthTokenSecret.length, @"OAuthTokenSecret required in Credentials.plist");
        
        [TMAPIClient sharedInstance].APIKey = APIKey;
        [TMAPIClient sharedInstance].OAuthConsumerKey = OAuthConsumerKey;
        [TMAPIClient sharedInstance].OAuthConsumerSecret = OAuthConsumerSecret;
        [TMAPIClient sharedInstance].OAuthToken = OAuthToken;
        [TMAPIClient sharedInstance].OAuthTokenSecret = OAuthTokenSecret;
        
        [credentials release];
    });
}

- (void)performAsynchronousTest:(void(^)(void))testCode {    
    self.receivedAsynchronousCallback = NO;
    
    testCode();
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    
    while (!self.receivedAsynchronousCallback && [loopUntil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    
    if (!self.receivedAsynchronousCallback)
        STFail(@"Request timed out");
}

@end
