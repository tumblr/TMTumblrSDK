//
//  TMURLSessionMetricsDelegate.h
//  Pods
//
//  Created by Kenny Ackerson on 11/2/16.
//
//

/*
 * A protocol for objects that can handle metrics for network requests.
 */
@protocol TMURLSessionMetricsDelegate

/*
 *  A method that objects that want to handle getting metrics updates about network requests can respond to.
 *
 *  @param task     The session task that the metrics are finished collecting for.
 *  @param metrics  Metrics about the network request that is represented by the session task.
 */
- (void)task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics;

@end
