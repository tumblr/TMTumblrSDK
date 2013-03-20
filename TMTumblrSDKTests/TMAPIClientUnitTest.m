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

- (void) testBlogInfoRequest {
    JXHTTPOperation *op = [client blogInfoRequest:@"b.n"];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testBlogInfo {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient blogInfo:@"b.n" callback:check];
    }];
}

- (void) testFollowersRequest {
    JXHTTPOperation *op = [client followersRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/followers"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowers {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient followers:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testAvatarRequest {
    JXHTTPOperation *op = [client avatarRequest:@"b.n" size:128];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/avatar/128"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testAvatar {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient avatar:@"b.n" size:64 callback:check];
    }];
}

- (void) testPostsRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:nil parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testPosts {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient posts:@"b.n" type:nil parameters:@{@"limit": @"1"} callback:check];
    }];
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
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient queue:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testDraftsRequest {
    JXHTTPOperation *op = [client draftsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/draft"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testDrafts {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient drafts:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testSubmissionsRequest {
    JXHTTPOperation *op = [client submissionsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/submission"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testSubmissions {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient submissions:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testTaggedRequest {
    JXHTTPOperation *op = [client taggedRequest:@"something" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/tagged"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1&tag=something"];
}

- (void) testTagged {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient tagged:@"tag" parameters:@{@"limit": @"1"} callback:check];
    }];
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

- (void) testPost {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient post:@"b.n" type:@"audio" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testEditPostRequest {
    JXHTTPOperation *op = [client editPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/edit"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testEditPost {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient editPost:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testReblogPostRequest {
    JXHTTPOperation *op = [client reblogPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/reblog"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testReblogPost {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient reblogPost:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testDeletePostRequest {
    JXHTTPOperation *op = [client deletePostRequest:@"b.n" id:@"123"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/delete"];
    [self assertBody:op   is:@{@"id": @"123", @"api_key": @"consumer_key"}];
}

- (void) testDeletePost {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient deletePost:@"b.n" id:@"123" callback:check];
    }];
}

- (void) testQuoteRequest {
    JXHTTPOperation *op = [client quoteRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"quote", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testQuote {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient quote:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testLinkRequest {
    JXHTTPOperation *op = [client linkRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"link", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testLink {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient link:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testChatRequest {
    JXHTTPOperation *op = [client chatRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"chat", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testChat {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient chat:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testPhotoRequest {
    JXHTTPOperation *op = [client photoRequest:@"b.n" filePathArray:@[@"somepath"] contentTypeArray:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testPhoto {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient photo:@"b.n" filePathArray:nil contentTypeArray:nil parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testAudioRequest {
    JXHTTPOperation *op = [client audioRequest:@"b.n" filePath:@"file" contentType:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testAudio {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient audio:@"b.n" filePath:nil contentType:nil parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testVideoRequest {
    JXHTTPOperation *op = [client videoRequest:@"b.n" filePath:@"file" contentType:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testVideo {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient video:@"b.n" filePath:nil contentType:nil parameters:@{@"limit": @"1"} callback:check];
    }];
}

/**
 HELPERS
*/

- (void) assertCallback:(void(^)(id, TMAPICallback))action {
    // Create a partial mock
    id mClient = [OCMockObject partialMockForObject:client];
    // Set up an expectation object
    NSDictionary *expectation = @{ @"some": @"data" };
    // Grab the callback and make sure we actually hit it
    [[[mClient stub] andDo:^(NSInvocation *invoc) {

        TMAPICallback cbk;
        [invoc getArgument:&cbk atIndex:3];
        cbk(expectation, nil);

        // TODO test actual HTTP call here on JXHTTPOperation
        
    }] sendRequest:[OCMArg isNotNil] callback:[OCMArg any]];
    // And then make the call and make sure we receive the proper data
    TMAPICallback check = ^(NSDictionary *data, NSError *error) {
        STAssertEquals(data, expectation, @"unexpected response");
    };
    action(mClient, check);
}

- (void) assertSimilarRequest:(JXHTTPOperation*)op1 to:(JXHTTPOperation*)op2 {
    [self assertMethod:op1 is:[op2 requestMethod]];
    // TODO rest
}

- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected {
    JXHTTPMultipartBody *body = (JXHTTPMultipartBody *) [op requestBody];
    NSLog(@"%lld", [body httpContentLength]);
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
