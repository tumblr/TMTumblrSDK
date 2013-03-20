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
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient userInfo:check];
    }];
}

- (void) testDashboardRequest {
    JXHTTPOperation *op = [client dashboardRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/dashboard"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testDashboard {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient dashboard:@{ @"limit": @"1" } callback:check];
    }];
}

- (void) testLikesRequest {
    JXHTTPOperation *op = [client likesRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/likes"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testLikes {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient likes:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testFollowingRequest {
    JXHTTPOperation *op = [client followingRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/following"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowing {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient following:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testFollowRequest {
    JXHTTPOperation *op = [client followRequest:@"blogname"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/follow"];
    [self assertBody:op   is:@{@"url": @"blogname.tumblr.com", @"api_key": @"consumer_key"}];
}

- (void) testFollow {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient follow:@"b.n" callback:check];
    }];
}

- (void) testUnfollowRequest {
    JXHTTPOperation *op = [client unfollowRequest:@"blogname.com"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unfollow"];
    [self assertBody:op   is:@{@"url": @"blogname.com", @"api_key": @"consumer_key"}];
}

- (void) testUnfollow {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient unfollow:@"b.n" callback:check];
    }];
}

- (void) testLikeRequest {
    JXHTTPOperation *op = [client likeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/like"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testLike {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient like:@"123" reblogKey:@"key" callback:check];
    }];
}

- (void) testUnlikeRequest {
    JXHTTPOperation *op = [client unlikeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unlike"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testUnlike {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient unlike:@"123" reblogKey:@"key" callback:check];
    }];
}

@end
