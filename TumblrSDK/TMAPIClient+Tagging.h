//
//  TMAPIClient+Tagging.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

@interface TMAPIClient (Tagging)

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error;

@end
