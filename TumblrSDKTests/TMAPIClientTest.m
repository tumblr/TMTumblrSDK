//
//  TMAPIClientTest.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/23/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClientTest.h"

#import "TMAPIClient.h"

@interface TMAPIClientTest()

@property (nonatomic, copy) NSString *blogName;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) TMAPICallback defaultCallback;
@property (nonatomic, assign) BOOL receivedAsynchronousCallback;
@property (nonatomic, retain) TMAPIClient *client;

@end

@implementation TMAPIClientTest

#pragma mark - Authentication

/*
 xAuth is not enabled by default but you can request it for your app: http://www.tumblr.com/oauth/apps
 
- (void)testXAuth {
    [self performAsynchronousTest:^ {
        [self.client xAuth:self.emailAddress password:self.password callback:self.defaultCallback];
    }];
}
 */

#pragma mark - User

- (void)testUserInfo {
    [self performAsynchronousTest:^ {
        [self.client userInfo:self.defaultCallback];
    }];
}

- (void)testDashboard {
    [self performAsynchronousTest:^ {
        [self.client dashboard:nil callback:self.defaultCallback];
    }];
}

- (void)testLikes {
    [self performAsynchronousTest:^ {
        [self.client likes:nil callback:self.defaultCallback];
    }];
}

- (void)testFollowing {
    [self performAsynchronousTest:^ {
        [self.client following:nil callback:self.defaultCallback];
    }];
}

/*
 Non-idempodent:
 
- (void)testFollow {
    [self performAsynchronousTest:^{
        [self.client follow:@"eatsleepdraw" callback:self.defaultCallback];
    }];
}

- (void)testUnfollow {
    [self performAsynchronousTest:^{
        [self.client unfollow:@"eatsleepdraw" callback:self.defaultCallback];
    }];
}

- (void)testLike {
    [self performAsynchronousTest:^{
        [self.client like:@"35942407679" reblogKey:@"In225E1x" callback:self.defaultCallback];
    }];
}

- (void)testUnlike {
    [self performAsynchronousTest:^{
        [self.client unlike:@"35942407679" reblogKey:@"In225E1x" callback:self.defaultCallback];
    }];
}
 */

#pragma mark - Blog

- (void)testBlogInfo {
    [self performAsynchronousTest:^ {
        [self.client blogInfo:self.blogName callback:self.defaultCallback];
    }];
}

- (void)testFollowers {
    [self performAsynchronousTest:^ {
        [self.client followers:self.blogName parameters:nil callback:self.defaultCallback];
    }];
}

- (void)testAvatar {
    [self performAsynchronousTest:^ {
        [self.client avatar:self.blogName size:64 callback:self.defaultCallback];
    }];
}

- (void)testPosts {
    [self performAsynchronousTest:^ {
        [self.client posts:self.blogName type:nil parameters:nil callback:self.defaultCallback];
    }];
}

- (void)testQueue {
    [self performAsynchronousTest:^ {
        [self.client queue:self.blogName parameters:nil callback:self.defaultCallback];
    }];
}

- (void)testDrafts {
    [self performAsynchronousTest:^ {
        [self.client drafts:self.blogName parameters:nil callback:self.defaultCallback];
    }];
}

- (void)testSubmissions {
    [self performAsynchronousTest:^ {
        [self.client submissions:self.blogName parameters:nil callback:self.defaultCallback];
    }];
}

- (void)testBlogLikes {
    [self performAsynchronousTest:^ {
        [self.client likes:@"bryan" parameters:nil callback:self.defaultCallback];
    }];
}

#pragma mark - Posting

/*
 Non-idempodent:
- (void)testEditPost {
    [self performAsynchronousTest:^{
        [self.client editPost:self.blogName parameters:
         @{ @"id" : @"35929255756", @"description" : @"Test description (edited)"} callback:self.defaultCallback];
    }];
}

- (void)testReblogPost {
    [self performAsynchronousTest:^{
        [self.client reblogPost:self.blogName parameters:
         @{ @"id" : @"35942407679", @"reblog_key" : @"In225E1x", @"comment" : @"Test comment" }
                       callback:self.defaultCallback];
    }];
}

- (void)testDeletePost {
    [self performAsynchronousTest:^{
        [self.client deletePost:self.blogName id:@"35928836726" callback:self.defaultCallback];
    }];
}
 
- (void)testTextPost {
    [self performAsynchronousTest:^ {
        [self.client text:self.blogName parameters:@{ @"title" : @"Test title", @"body" : @"Test body" }
                 callback:self.defaultCallback];
    }];
}

- (void)testQuotePost {
    [self performAsynchronousTest:^ {
        [self.client quote:self.blogName parameters:@{ @"quote" : @"Test quote", @"source" : @"Test source" }
                 callback:self.defaultCallback];
    }];
}

- (void)testLinkPost {
    [self performAsynchronousTest:^ {
        [self.client link:self.blogName parameters:@{ @"title" : @"Test title", @"url" : @"http://bryan.io",
         @"description" : @"Test description" } callback:self.defaultCallback];
    }];
}

- (void)testChatPost {
    [self performAsynchronousTest:^ {
        [self.client chat:self.blogName parameters:@{ @"title" : @"Test title", @"conversation" : @"Bryan: It worked!" }
                 callback:self.defaultCallback];
    }];
}
 */
/*
- (void)testPhotoPostFromData {
    [self performAsynchronousTest:^{
        NSData *data = [NSData dataWithContentsOfFile:
                        [[NSBundle bundleForClass:[TMTumblrSDKTests class]] pathForResource:@"burrito" ofType:@"png"]];
        
        [self.client photo:self.blogName data:data contentType:@"image/png" parameters:
         @{ @"caption" : @"Yum (from data)" } callback:self.defaultCallback];
    }];
}
 */
- (void)testPhotoPostFromFile {
    [self performAsynchronousTest:^{
        NSString *filePath = [[NSBundle bundleForClass:[TMAPIClientTest class]] pathForResource:@"burrito" ofType:@"png"];
        
        [self.client photo:self.blogName filePath:filePath contentType:@"image/png" parameters:
         @{ @"caption" : @"Yum (from file)" } callback:self.defaultCallback];
    }];
}

#warning Audio
#warning Video
#warning Photoset

#pragma mark - Tags

- (void)testTagged {
    [self performAsynchronousTest:^ {
        [self.client tagged:@"lol" parameters:nil callback:self.defaultCallback];
    }];
}

#pragma mark - Common

- (void)setUp {
    [super setUp];
        
    __block TMAPIClientTest *blockSelf = self;
    
    self.defaultCallback = ^ (id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            STFail(@"Request failed");
        } else {
            STAssertNotNil(result, @"Response cannot be nil");
        }
        
        blockSelf.receivedAsynchronousCallback = YES;
    };
    
    self.client = [TMAPIClient sharedInstance];
    
    NSDictionary *credentials = [[NSDictionary alloc] initWithContentsOfFile:
                                 [[NSBundle bundleForClass:[TMAPIClientTest class]] pathForResource:@"Credentials"
                                                                                             ofType:@"plist"]];
    
    NSString *OAuthConsumerKey = credentials[@"OAuthConsumerKey"];
    NSString *OAuthConsumerSecret = credentials[@"OAuthConsumerSecret"];
    NSString *OAuthToken = credentials[@"OAuthToken"];
    NSString *OAuthTokenSecret = credentials[@"OAuthTokenSecret"];
    NSString *emailAddress = credentials[@"EmailAddress"];
    NSString *password = credentials[@"Password"];
    NSString *blogName = credentials[@"BlogName"];
    
    STAssertTrue(OAuthConsumerKey.length, @"OAuthConsumerKey required in Credentials.plist");
    STAssertTrue(OAuthConsumerSecret.length, @"OAuthConsumerSecret required in Credentials.plist");
    STAssertTrue(OAuthToken.length, @"OAuthToken required in Credentials.plist");
    STAssertTrue(OAuthTokenSecret.length, @"OAuthTokenSecret required in Credentials.plist");
    
    /*
    STAssertTrue(emailAddress.length, @"EmailAddress required in Credentials.plist");
    STAssertTrue(password.length, @"Password required in Credentials.plist");
    STAssertTrue(blogName.length, @"BlogName required in Credentials.plist");
     */
    
    self.client.OAuthConsumerKey = OAuthConsumerKey;
    self.client.OAuthConsumerSecret = OAuthConsumerSecret;
    self.client.OAuthToken = OAuthToken;
    self.client.OAuthTokenSecret = OAuthTokenSecret;
    
    self.emailAddress = emailAddress;
    self.password = password;
    self.blogName = blogName;
    
    [credentials release];
}

- (void)performAsynchronousTest:(void(^)(void))testCode {
    self.receivedAsynchronousCallback = NO;
    
    testCode();
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    
    while (!self.receivedAsynchronousCallback && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        
        // Not sure why this is necessary but I get EXC_BAD_ACCESS on the above line otherwise
        [NSThread sleepForTimeInterval:0.05];
    }
    
    if (!self.receivedAsynchronousCallback)
        STFail(@"Request timed out");
}

@end
