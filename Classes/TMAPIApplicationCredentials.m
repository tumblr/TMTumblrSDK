//
//  TMTumblrAppCredentials.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 9/22/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "TMAPIApplicationCredentials.h"

@implementation TMAPIApplicationCredentials

#pragma mark - Initialization

- (instancetype)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    NSParameterAssert(consumerKey);
    NSParameterAssert(consumerSecret);
    
    if (self = [super init]) {
        _consumerKey = [consumerKey copy];
        _consumerSecret = [consumerSecret copy];
    }
    
    return self;
}

- (BOOL)validCredentials {
    return self.consumerKey.length > 0 && self.consumerSecret.length > 0;
}

@end
