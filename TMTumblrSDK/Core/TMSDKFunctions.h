//
//  TMSDKFunctions.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/24/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

@import Foundation;

@interface TMSDKFunctions : NSObject

NSString *TMURLDecode(NSString *string);

NSString *TMURLEncode(NSString *string);

NSDictionary *TMQueryStringToDictionary(NSString *query);

NSString *TMDictionaryToQueryString(NSDictionary *dictionary);

@end
