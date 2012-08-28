//
//  TMAPIClient+User.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (User)

- (void)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error;

- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

@end
