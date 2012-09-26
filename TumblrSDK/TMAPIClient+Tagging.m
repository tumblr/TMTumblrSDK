//
//  TMAPIClient+Tagging.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Tagging.h"

@implementation TMAPIClient (Tagging)

- (NSOperation *)tagged:(NSString *)tag parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"tagged" parameters:parameters callback:callback];
}

@end
