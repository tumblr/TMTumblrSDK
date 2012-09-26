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
    NSMutableDictionary *mutableParameters = parameters
            ? [NSMutableDictionary dictionaryWithDictionary:parameters]
            : [NSMutableDictionary dictionary];
    mutableParameters[TMAPIParameterTag] = tag;
    mutableParameters[TMAPIParameterAPIKey] = self.OAuthConsumerKey;
    
    return [self get:@"tagged" parameters:mutableParameters callback:callback];
}

@end
