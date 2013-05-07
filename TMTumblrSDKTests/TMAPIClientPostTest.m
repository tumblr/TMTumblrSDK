//
//  TMAPIClientPostTest.m
//  TMTumblrSDK
//
//  Created by John Crepezzi on 3/20/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientPostTest.h"

@implementation TMAPIClientPostTest

@synthesize client;

- (void) testPostRequest {
    JXHTTPOperation *op = [client postRequest:@"b.n" type:@"audio" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"audio", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testPost {
    NSString *blogName = @"blog";
    NSString *type = @"audio";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client postRequest:blogName type:type parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient post:blogName type:type parameters:params callback:check];
    } andVerify:op];
}

- (void) testEditPostRequest {
    JXHTTPOperation *op = [client editPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/edit"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testEditPost {
    NSString *blogName = @"blog";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client editPostRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient editPost:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testReblogPostRequest {
    JXHTTPOperation *op = [client reblogPostRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/reblog"];
    [self assertBody:op   is:@{@"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testReblogPost {
    NSString *blogName = @"blog";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client reblogPostRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient reblogPost:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testDeletePostRequest {
    JXHTTPOperation *op = [client deletePostRequest:@"b.n" id:@"123"];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post/delete"];
    [self assertBody:op   is:@{@"id": @"123", @"api_key": @"consumer_key"}];
}

- (void) testDeletePost {
    NSString *blogName = @"blog";
    NSString *postId = @"123";
    JXHTTPOperation *op = [client deletePostRequest:blogName id:postId];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient deletePost:blogName id:postId callback:check];
    } andVerify:op];
}

- (void) testQuoteRequest {
    JXHTTPOperation *op = [client quoteRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"quote", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testQuote {
    NSString *blogName = @"blog";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client quoteRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient quote:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testLinkRequest {
    JXHTTPOperation *op = [client linkRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"link", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testLink {
    NSString *blogName = @"blog";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client linkRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient link:blogName  parameters:params callback:check];
    } andVerify:op];
}

- (void) testChatRequest {
    JXHTTPOperation *op = [client chatRequest:@"b.n" parameters:@{@"name": @"test"}];
    [self assertMethod:op is:@"POST"];
    [self assertPath:op   is:@"/v2/blog/b.n/post"];
    [self assertBody:op   is:@{@"type": @"chat", @"name": @"test", @"api_key": @"consumer_key"}];
}

- (void) testChat {
    NSString *blogName = @"blog";
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client chatRequest:blogName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient chat:blogName parameters:params callback:check];
    } andVerify:op];
}

- (void) testPhotoRequest {
    JXHTTPOperation *op = [client photoRequest:@"b.n" filePathArray:@[@"somepath"] contentTypeArray:nil fileNameArray:@[@"somename"] parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testPhoto {
    NSString *blogName = @"blog";
    NSArray *filePathArray = nil;
    NSArray *contentTypeArray = nil;
    NSArray *fileNameArray = nil;
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client photoRequest:blogName filePathArray:filePathArray contentTypeArray:contentTypeArray fileNameArray:fileNameArray parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient photo:blogName filePathArray:filePathArray contentTypeArray:contentTypeArray fileNameArray:fileNameArray parameters:params callback:check];
    } andVerify:op];
}

- (void) testAudioRequest {
    JXHTTPOperation *op = [client audioRequest:@"b.n" filePath:@"file" contentType:nil fileName:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testAudio {
    NSString *blogName = @"blog";
    NSString *filePath = nil;
    NSString *contentType = nil;
    NSString *fileName = nil;
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client audioRequest:blogName filePath:filePath contentType:contentType fileName:fileName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient audio:blogName filePath:filePath contentType:contentType fileName:fileName parameters:params callback:check];
    } andVerify:op];
}

- (void) testVideoRequest {
    JXHTTPOperation *op = [client videoRequest:@"b.n" filePath:@"file" contentType:nil fileName:nil parameters:@{@"name": @"test"}];
    [self assertMethod:op        is:@"POST"];
    [self assertPath:op          is:@"/v2/blog/b.n/post"];
    [self assertMultipartBody:op is:@"TODO"];
}

- (void) testVideo {
    NSString *blogName = @"blog";
    NSString *filePath = nil;
    NSString *contentType = nil;
    NSString *fileName = nil;
    NSDictionary *params = @{@"some": @"param"};
    JXHTTPOperation *op = [client videoRequest:blogName filePath:filePath contentType:contentType fileName:fileName parameters:params];
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient video:blogName filePath:filePath contentType:contentType fileName:fileName parameters:params callback:check];
    } andVerify:op];
}

@end
