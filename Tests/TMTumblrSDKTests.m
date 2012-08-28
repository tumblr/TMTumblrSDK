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
@property (nonatomic, retain) TMAPIClient *client;

- (void)performAsynchronousTest:(void(^)(void))testCode;

@end

@implementation TMTumblrSDKTests

#pragma mark - Tests

// Blog methods

- (void)testBlogInfo {
    [self performAsynchronousTest:^ {
        [_client blogInfo:@"bryan"
                  success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testFollowers {
    [self performAsynchronousTest:^ {
        [_client followers:@"bryan" parameters:nil
                   success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testAvatar {
    [self performAsynchronousTest:^ {
        [_client avatar:@"bryan" size:64
                success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testPosts {
    [self performAsynchronousTest:^ {
        [_client posts:@"bryan" type:nil parameters:nil
               success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testQueue {
    [self performAsynchronousTest:^ {
        [_client queue:@"bryan" parameters:nil
               success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testDrafts {
    [self performAsynchronousTest:^ {
        [_client drafts:@"bryan" parameters:nil
                success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testSubmissions {
    [self performAsynchronousTest:^ {
        [_client submissions:@"bryan" parameters:nil
                     success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

// User methods

- (void)testUserInfo {
    [self performAsynchronousTest:^ {
        [_client userInfo:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testDashboard {
    [self performAsynchronousTest:^ {
        [_client dashboard:nil
                   success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testLikes {
    [self performAsynchronousTest:^ {
        [_client likes:nil
               success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

- (void)testFollowing {
    [self performAsynchronousTest:^ {
        [_client following:nil
                   success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

// Tagged methods

- (void)testTagged {
    [self performAsynchronousTest:^ {
        [_client tagged:@"lol" parameters:nil
                success:_defaultSuccessCallback error:_defaultErrorCallback];
    }];
}

#pragma mark - Common

- (void)setUp {
    [super setUp];
    
    self.defaultSuccessCallback = ^ (NSDictionary *result) {
        NSLog(@"%@", result);
        
        STAssertNotNil(result, @"Response cannot be nil");
        
        self.receivedAsynchronousCallback = YES;
    };
    
    self.defaultErrorCallback = ^ (NSError *error) {
        NSLog(@"%@", error);
        
        STFail(@"Request failed");
        
        self.receivedAsynchronousCallback = YES;
    };    
    
    self.client = [TMAPIClient sharedInstance];
    
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
