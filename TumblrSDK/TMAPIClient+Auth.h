//
//  TMAPIClient+Auth.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/30/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Auth)

- (void)xAuthRequest:(NSString *)userName password:(NSString *)password;

@end
