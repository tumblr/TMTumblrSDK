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

@end
