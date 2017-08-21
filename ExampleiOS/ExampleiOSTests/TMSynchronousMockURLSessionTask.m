//
//  TMSynchronousMockURLSessionTask.m
//  ExampleiOS
//
//  Created by Tyler Tape on 5/3/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import "TMSynchronousMockURLSessionTask.h"


@interface TMSynchronousMockURLSessionTask ()

@property (nonatomic, readonly) NSData *dummyData;
@property (nonatomic, readonly) NSURLResponse *dummyResponse;
@property (nonatomic, readonly) NSError *dummyError;

@end

@implementation TMSynchronousMockURLSessionTask

- (instancetype)initWithDummyData:(NSData *)data dummyResponse:(NSURLResponse *)response dummyError:(NSError *)error {
    self = [super init];
    if (self) {
        _dummyData = [data copy];
        _dummyResponse = response;
        _dummyError = error;
    }
    return self;
}

- (void)resume {
    self.completionHandler(self.dummyData, self.dummyResponse, self.dummyError);
}

@end
