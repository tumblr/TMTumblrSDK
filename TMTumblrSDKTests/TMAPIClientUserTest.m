//
//  TMAPIClientUserTest.m
//  TMTumblrSDK
//
//  Created by John Crepezzi on 3/20/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientUserTest.h"

@implementation TMAPIClientUserTest

@synthesize client;

- (void) testUserInfoRequest {
    JXHTTPOperation *op = [client userInfoRequest];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testUserInfo {
    JXHTTPOperation *op = [client userInfoRequest];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient userInfo:check];
    } andVerify:op];
}

- (void) testDashboardRequest {
    JXHTTPOperation *op = [client dashboardRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/dashboard"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testDashboard {
    NSDictionary *params = @{@"url": @"1"};
    JXHTTPOperation *op = [client dashboardRequest:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient dashboard:params callback:check];
    } andVerify:op];
}

- (void) testLikesRequest {
    JXHTTPOperation *op = [client likesRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/likes"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testLikes {
    NSDictionary *params = @{@"url": @"1"};
    JXHTTPOperation *op = [client likesRequest:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient likes:params callback:check];
    } andVerify:op];
}

- (void) testFollowingRequest {
    JXHTTPOperation *op = [client followingRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/following"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowing {
    NSDictionary *params = @{@"url": @"1"};
    JXHTTPOperation *op = [client followingRequest:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient following:params callback:check];
    } andVerify:op];
}

- (void) testFollowRequest {
    JXHTTPOperation *op = [client followRequest:@"blogname"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/follow"];
    [self assertBody:op   is:@{@"url": @"blogname.tumblr.com", @"api_key": @"consumer_key"}];
}

- (void) testFollow {
    NSString *blogName = @"b.n";
    JXHTTPOperation *op = [client followRequest:blogName];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient follow:blogName callback:check];
    } andVerify:op];
}

- (void) testUnfollowRequest {
    JXHTTPOperation *op = [client unfollowRequest:@"blogname.com"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unfollow"];
    [self assertBody:op   is:@{@"url": @"blogname.com", @"api_key": @"consumer_key"}];
}

- (void) testUnfollow {
    NSString *blogName = @"b.n";
    JXHTTPOperation *op = [client unfollowRequest:blogName];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient unfollow:@"b.n" callback:check];
    } andVerify:op];
}

- (void) testLikeRequest {
    JXHTTPOperation *op = [client likeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/like"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testLike {
    NSString *postId = @"123";
    NSString *reblogKey = @"key";
    JXHTTPOperation *op = [client likeRequest:postId reblogKey:reblogKey];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient like:postId reblogKey:reblogKey callback:check];
    } andVerify:op];
}

- (void) testUnlikeRequest {
    JXHTTPOperation *op = [client unlikeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unlike"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testUnlike {
    NSString *postId = @"123";
    NSString *reblogKey = @"key";
    JXHTTPOperation *op = [client unlikeRequest:postId reblogKey:reblogKey];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient unlike:@"123" reblogKey:@"key" callback:check];
    } andVerify:op];
}

@end
