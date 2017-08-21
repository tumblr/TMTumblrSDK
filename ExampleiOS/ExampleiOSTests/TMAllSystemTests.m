//
//  TMAllSystemTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/16/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMAPIClient.h>
#import "TMBasicBaseURLDeterminer.h"

@interface TMAllSystemTests : XCTestCase

@end

@implementation TMAllSystemTests

- (void)testURLPathsAreRight {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
    TMAPIClient *client = [[TMAPIClient alloc] initWithSession:[[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@""] userCredentials:[[TMAPIUserCredentials alloc] initWithToken:@"" tokenSecret:@""]] requestFactory:requestFactory];

    void (^callback)(NSDictionary * _Nullable, NSError * _Nullable) = ^(NSDictionary * _Nullable response, NSError * _Nullable error) {

    };

    void (^callbackForData)(NSData *data, NSURLResponse * _Nullable response, NSError * _Nullable error) = ^(NSData *data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    };

    NSArray *methods = @[
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"POST",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"GET",
                         @"POST",
                         @"POST",
                         @"POST",
                         @"POST",
                         @"POST",
                         @"POST",
                         @"GET",
                         @"POST",
                         @"GET",
                         @"GET"
                         ];

    NSArray *routes = @[
                        @"user/info",
                        @"blog/ios/notes",
                        @"user/likes",
                        @"user/following",
                        @"blog/ios.tumblr.com/avatar/64",
                        @"blog/ios.tumblr.com/post/edit",
                        @"blog/ios.tumblr.com/posts/submission",
                        @"blog/ios.tumblr.com/posts/draft",
                        @"blog/t:HxFRdt0Yhn2qG8zsmKuHMA/likes",
                        @"blog/ios.tumblr.com/info",
                        @"blog/ios.tumblr.com/followers",
                        @"blog/ios.tumblr.com/posts",
                        @"blog/ios.tumblr.com/posts",
                        @"user/unlike",
                        @"user/unfollow",
                        @"user/follow",
                        @"blog/ios.tumblr.com/post/delete",
                        @"user/like",
                        @"user/like",
                        @"blog/ios.tumblr.com/posts/queue",
                        @"blog/ios.tumblr.com/post/reblog",
                        @"blog/t:HxFRdt0Yhn2qG8zsmKuHMA/info"
                        ];

    NSArray *tasks = @[
                       [client userInfoDataTaskWithCallback:callback],
                       [client notesDataTaskWithPostID:@"" blogUUID:@"ios" beforeDate:nil :callback],
                       [client likesDataTaskWithParameters:@{} callback:callback],
                       [client followingDataTaskWithParameters:@{} callback:callback],
                       [client avatarWithBlogName:@"ios" size:64 callback:callbackForData],
                       [client editPost:@"ios" parameters:@{} callback:callback],
                       [client submissionsRequestforBlogName:@"ios" parameters:@{} callback:callback],
                       [client draftsRequestForBlogWithName:@"ios" parameters:@{} callback:callback],
                       [client likesDataTaskForBlogWithUUID:@"t:HxFRdt0Yhn2qG8zsmKuHMA" parameters:@{} callback:callback],
                       [client blogInfoDataTaskForBlogName:@"ios" callback:callback],
                       [client followersRequestForBlogName:@"ios" parameters:@{} callback:callback],
                       [client postsTask:@"ios" type:@"" queryParameters:@{} callback:callback],
                       [client postDataTaskWithBlogName:@"ios" type:@"" parameters:@{} callback:callbackForData],
                       [client taskWithRequest:[requestFactory unlikeRequest:@"" reblogKey:@""] callback:callback],
                       [client taskWithRequest:[requestFactory unfollowRequest:@"ios"] callback:callback],
                       [client taskWithRequest:[requestFactory followRequest:@"ios" parameters:@{}] callback:callback],
                       [client taskWithRequest:[requestFactory deletePostRequest:@"ios" postID:@"1"] callback:callback],
                       [client taskWithRequest:[requestFactory likeRequest:@"" reblogKey:@""] callback:callback],
                       [client taskWithRequest:[requestFactory likeRequest:@"" reblogKey:@"" additionalParameters:@{}] callback:callback],
                       [client taskWithRequest:[requestFactory queueRequestForBlogWithName:@"ios" queryParameters:@{}] callback:callback],
                       [client taskWithRequest:[requestFactory reblogPostRequestWithBlogName:@"ios" parameters:@{}] callback:callback],
                       [client taskWithRequest:[requestFactory blogInfoRequestForBlogUUID:@"t:HxFRdt0Yhn2qG8zsmKuHMA"] callback:callback],
                       [client taskWithRequest:[requestFactory dashboardRequest:nil] callback:callback]
                       ];

    NSArray *requests = @[
                          [requestFactory userInfoRequest],
                          [requestFactory notesRequestWithPostID:@"" blogUUID:@"ios" beforeDate:nil],
                          [requestFactory likesRequestWithParameters:@{}],
                          [requestFactory followingRequestWithParameters:@{}],
                          [requestFactory avatarWithBlogName:@"ios" size:64],
                          [requestFactory editPostRequest:@"ios" parameters:@{}],
                          [requestFactory sumbissionsRequestForBlog:@"ios" queryParameters:@{}],
                          [requestFactory draftsRequestForBlog:@"ios" queryParameters:@{}],
                          [requestFactory likesRequestForBlogWithUUID:@"t:HxFRdt0Yhn2qG8zsmKuHMA" queryParameters:@{}],
                          [requestFactory blogInfoRequestForBlogName:@"ios"],
                          [requestFactory followersRequestForBlog:@"ios" queryParameters:@{}],
                          [requestFactory postsRequestWithBlogName:@"ios" type:@"" queryParameters:@{}],
                          [requestFactory postRequestWithBlogName:@"ios" type:@"" parameters:@{}],
                          [requestFactory unlikeRequest:@"" reblogKey:@""],
                          [requestFactory unfollowRequest:@"ios"],
                          [requestFactory followRequest:@"ios" parameters:@{}],
                          [requestFactory deletePostRequest:@"ios" postID:@"1"],
                          [requestFactory likeRequest:@"" reblogKey:@""],
                          [requestFactory likeRequest:@"" reblogKey:@"" additionalParameters:@{}],
                          [requestFactory queueRequestForBlogWithName:@"ios" queryParameters:@{}],
                          [requestFactory reblogPostRequestWithBlogName:@"ios" parameters:@{}],
                          [requestFactory blogInfoRequestForBlogUUID:@"t:HxFRdt0Yhn2qG8zsmKuHMA"],
                          [requestFactory dashboardRequest:nil]
                        ];

    for (NSInteger i = 0; i < routes.count; i++) {
        XCTAssert([self sessionTask:tasks[i] request:requests[i] isUsingPath:routes[i]]);

        XCTAssert([[tasks[i] currentRequest].HTTPMethod isEqual:methods[i]], @"Item %ld did not work correctly", i );
    }

}

- (BOOL)sessionTask:(NSURLSessionTask *)sessionTask request:(id <TMRequest>)request isUsingPath:(NSString *)path {
    return [[[sessionTask.currentRequest URL] absoluteString] containsString:[@"https://api.tumblr.com/v2/" stringByAppendingString:path]];
}

@end
