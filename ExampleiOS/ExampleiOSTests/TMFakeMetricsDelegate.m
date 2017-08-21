//
//  TMFakeMetricsDelegate.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 11/3/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import "TMFakeMetricsDelegate.h"

@interface TMFakeMetricsDelegate ()

@property (nonatomic) NSURLSessionTask *task;
@property (nonatomic) NSURLSessionTaskMetrics *metrics;

@end

@implementation TMFakeMetricsDelegate

- (void)task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {

    self.task = task;
    self.metrics = metrics;
}

@end
