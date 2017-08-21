//
//  TMSDKFunctions.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/24/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

@import Foundation;

@interface TMSDKFunctions : NSObject

NSString * _Nullable TMURLDecode(NSString * _Nonnull string);

NSString * _Nonnull TMURLEncode(NSString * _Nonnull string);

NSDictionary * _Nonnull TMQueryStringToDictionary(NSString * _Nullable query);

NSString * _Nonnull TMDictionaryToQueryString(NSDictionary * _Nonnull dictionary);

NSString * _Nonnull blogPath(NSString * _Nonnull ext, NSString * _Nonnull blogName);

NSString * _Nonnull fullBlogName(NSString * _Nonnull blogName);

@end
