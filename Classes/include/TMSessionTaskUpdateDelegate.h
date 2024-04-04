//
//  TMSessionTaskUpdateDelegate.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/7/16.
//
//

/**
 *  A protocol for types that wish to get updates to tasks statuses.
 */
@protocol TMSessionTaskUpdateDelegate

/**
 *  Called when the session task is updated.
 *
 *  @param task  The session task whose status has been updated.
 *  @param state The state it has been updated to.
 */
- (void)URLSession:(nonnull NSURLSessionTask *)task updatedStatusTo:(TMURLSessionTaskState)state;

@end
