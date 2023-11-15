//
//  TMBaseURLDetermining.h
//  Pods
//
//  Created by Tyler Tape on 5/30/17.
//
//

#import <Foundation/Foundation.h>

/**
 Protocol for objects that can provide a base URL for network requests.
 */
@protocol TMBaseURLDetermining

/**
 A base URL for making requests to the Tumblr API

 @return The base URL
 */
- (NSURL *)baseURL;

@end
