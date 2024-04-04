//
//  TMFakeMetricsDelegate.h
//  ExampleiOS
//
//  Created by Kenny Ackerson on 11/3/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
@import TMTumblrSDK;

__attribute__((objc_subclassing_restricted))
@interface TMFakeMetricsDelegate : NSObject <TMURLSessionMetricsDelegate>

@property (nonatomic, readonly) NSURLSessionTask *task;

@property (nonatomic, readonly) NSURLSessionTaskMetrics *metrics;

@end
