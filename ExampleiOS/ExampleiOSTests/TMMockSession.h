//
//  TMMockSession.h
//  ExampleiOS
//
//  Created by Tyler Tape on 5/3/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMTumblrSDK/TMSession.h>
#import "TMSynchronousMockURLSessionTask.h"

/**
 A fake session that allows us to swap in mocks for @c NSURLSession tasks
 */
@interface TMMockSession : NSObject <TMSession>

/**
 Designated initializer

 @param taskDictionary A dictionary from a request's URL string to the mock task we wish to use instead
 @return A new @c TMMockSession
 */
- (instancetype)initWithMockTaskDictionary:(NSDictionary *)taskDictionary;

@end
