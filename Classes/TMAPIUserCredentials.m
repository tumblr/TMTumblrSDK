//
//  TMAPIUserCredentials.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 4/1/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

#import "TMAPIUserCredentials.h"

@implementation TMAPIUserCredentials

- (instancetype)initWithToken:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    self = [super init];
    if (self) {
        _token = [token copy];
        _tokenSecret = [tokenSecret copy];
    }
    
    return self;
}

- (BOOL)validCredentials {
    return self.token.length > 0 && self.tokenSecret.length > 0;
}

- (instancetype)init {
    return [self initWithToken:@"" tokenSecret:@""];
}

@end
