//
//  TMAPIClient+Auth.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/30/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Auth)

- (JXHTTPOperation *)xAuthRequest:(NSString *)userName password:(NSString *)password callback:(TMAPICallback)callback;

@end
