//
//  TMAPIClientBlogTest.m
//  TMTumblrSDK
//
//  Created by John Crepezzi on 3/20/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientBlogTest.h"

@implementation TMAPIClientBlogTest

@synthesize client;

- (void) testBlogInfoRequest {
    JXHTTPOperation *op = [client blogInfoRequest:@"b.n"];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testBlogInfo {
    NSString *blogName = @"b.n";
    JXHTTPOperation *op = [client blogInfoRequest:blogName];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient blogInfo:blogName callback:check];
    } andVerify:op];
}

- (void) testFollowersRequest {
    JXHTTPOperation *op = [client followersRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/followers"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowers {
    NSString *blogName = @"b.n";
    NSDictionary *params = @{ @"limit": @"1" };
    JXHTTPOperation *op = [client followersRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient followers:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testAvatarRequest {
    // TODO
}

- (void) testAvatar {
    // TODO
}

- (void) testPostsRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:nil parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testPosts {
    NSString *blogName = @"b.n";
    NSString *type = nil;
    NSDictionary *params = @{@"limit": @"1"};
    JXHTTPOperation *op = [client postsRequest:blogName type:type parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient posts:blogName type:type parameters:params callback:check];
    } andVerify:op];
}

- (void) testPosts_WithTypeRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:@"audio" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/audio"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testQueueRequest {
    JXHTTPOperation *op = [client queueRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/queue"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testQueue {
    NSString *blogName = @"b.n";
    NSDictionary *params = @{@"limit": @"1"};
    JXHTTPOperation *op = [client queueRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient queue:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testDraftsRequest {
    JXHTTPOperation *op = [client draftsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/draft"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testDrafts {
    NSString *blogName = @"b.n";
    NSDictionary *params = @{@"limit": @"1"};
    JXHTTPOperation *op = [client draftsRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient drafts:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testSubmissionsRequest {
    JXHTTPOperation *op = [client submissionsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/submission"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testSubmissions {
    NSString *blogName = @"b.n";
    NSDictionary *params = @{@"limit": @"1"};
    JXHTTPOperation *op = [client submissionsRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient submissions:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    } andVerify:op];
}

@end
