//
//  TMURLConcreteSessionTaskDelegateContainer.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/28/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSessionCallbacks.h"

/**
 *  Responsible for holding data for the concrete session deelgate can use.
 */
__attribute__((objc_subclassing_restricted))
@interface TMURLConcreteSessionTaskDelegateContainer : NSObject

/**
 *  The completion handler for requests.
 */
@property (nonatomic, copy, nonnull, readonly) TMURLSessionRequestCompletionHandler completionHandler;

/**
 *  The incremental handler for request.
 */
@property (nonatomic, copy, nonnull, readonly) TMURLSessionRequestIncrementedHandler incrementalHandler;

@property (nonatomic, copy, nonnull, readonly) TMURLSessionRequestProgressHandler progressHandler;

/**
 *  Data to append incremental data to.
 */
@property (nonatomic, nonnull, readonly) NSMutableData *data;

/**
 *  The current progress of the data sending up to the server.
 */
@property (nonatomic) double uploadProgress;

/**
 *  Initializes an instance of @c TMURLConcreteSessionTaskDelegateContainer.
 *
 *  @param completionHandler  A handler to be called after the request completes.
 *  @param incrementalHandler A handler to call when we get incremental data returned from the server.
 *  @param data               The data 
 *
 *  @return Initialized an instance of @c TMURLConcreteSessionTaskDelegateContainer.
 */
- (nonnull instancetype)initWithCompletionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler
                               incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
                                  progressHandler:(nonnull  TMURLSessionRequestProgressHandler)progressHandler
                                             data:(nonnull NSMutableData *)data;

@end
