//
//  TMAPIClientUnitTest.m
//  TumblrSDK
//
//  Created by John Crepezzi on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientUnitTest.h"

@implementation TMAPIClientUnitTest

@synthesize client;

- (void) setUp {
    self.client = [TMAPIClient sharedInstance];
    [client setOAuthConsumerKey:@"consumer_key"];
}

- (void) testUserInfoRequest {
    JXHTTPOperation *op = [client userInfoRequest];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testDashboardRequest {
    JXHTTPOperation *op = [client dashboardRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/dashboard"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testLikesRequest {
    JXHTTPOperation *op = [client likesRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/likes"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowingRequest {
    JXHTTPOperation *op = [client followingRequest:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/user/following"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowRequest {
    JXHTTPOperation *op = [client followRequest:@"blogname"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/follow"];
    [self assertBody:op   is:@{@"url": @"blogname.tumblr.com", @"api_key": @"consumer_key"}];
}

- (void) testUnfollowRequest {
    JXHTTPOperation *op = [client unfollowRequest:@"blogname.com"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unfollow"];
    [self assertBody:op   is:@{@"url": @"blogname.com", @"api_key": @"consumer_key"}];
}

- (void) testLikeRequest {
    JXHTTPOperation *op = [client likeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/like"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testUnlikeRequest {
    JXHTTPOperation *op = [client unlikeRequest:@"the_id" reblogKey:@"reblogKey"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/user/unlike"];
    [self assertBody:op   is:@{@"id": @"the_id", @"reblog_key": @"reblogKey", @"api_key": @"consumer_key"}];
}

- (void) testBlogInfoRequest {
    JXHTTPOperation *op = [client blogInfoRequest:@"b.n"];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testFollowersRequest {
    JXHTTPOperation *op = [client followersRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/followers"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testAvatarRequest {
    JXHTTPOperation *op = [client avatarRequest:@"b.n" size:128];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/avatar/128"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testPostsRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:nil parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
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

- (void) testDraftsRequest {
    JXHTTPOperation *op = [client draftsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/draft"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testSubmissionsRequest {
    JXHTTPOperation *op = [client submissionsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/submission"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testTaggedRequest {
    JXHTTPOperation *op = [client taggedRequest:@"something" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/tagged"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1&tag=something"];
}

- (void) testTaggedRequest_NoParameters {
    JXHTTPOperation *op = [client taggedRequest:@"something" parameters:nil];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/tagged"];
    [self assertQuery:op  is:@"api_key=consumer_key&tag=something"];
}

- (void) testPostRequest {
    JXHTTPOperation *op = [client postRequest:@"b.n" type:@"audio" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"audio", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testEditPostRequest {
    JXHTTPOperation *op = [client editPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/edit"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testReblogPostRequest {
    JXHTTPOperation *op = [client reblogPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/reblog"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testDeletePostRequest {
    JXHTTPOperation *op = [client deletePostRequest:@"b.n" id:@"123"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/delete"];
    [self assertBody:op   is:@{@"id": @"123", @"api_key": @"consumer_key"}];
}

- (void) testQuoteRequest {
    JXHTTPOperation *op = [client quoteRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"quote", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testLinkRequest {
    JXHTTPOperation *op = [client linkRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"link", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testChatRequest {
    JXHTTPOperation *op = [client chatRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"chat", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testPhotoRequest {
    JXHTTPOperation *op = [client photoRequest:@"b.n" filePathArray:@[@"somepath"] contentTypeArray:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testAudioRequest {
    JXHTTPOperation *op = [client audioRequest:@"b.n" filePath:@"somepath" contentType:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testVideoRequest {
    JXHTTPOperation *op = [client videoRequest:@"b.n" filePath:@"somepath" contentType:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

/**
 HELPERS
*/

- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected {
    JXHTTPMultipartBody *body = (JXHTTPMultipartBody *) [op requestBody];
    /* COMING SOON */
}

- (void) assertBody:(JXHTTPOperation*)op is:(NSDictionary*)expected {
    JXHTTPFormEncodedBody *body = (JXHTTPFormEncodedBody *) [op requestBody];
    STAssertEqualObjects([body dictionary], expected, @"wrong url");
}

- (void) assertQuery:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([[[op request] URL] query], expected, @"wrong request query");
}

-(void) assertPath:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([[[op request] URL] path], expected, @"wrong request path");
}

-(void) assertMethod:(JXHTTPOperation*)op is:(NSString*)expected {
    STAssertEqualObjects([op requestMethod], expected, @"wrong request method");
}

@end
