//
//  TMBasicBaseURLDeterminer.h
//  Pods
//
//  Created by Tyler Tape on 6/1/17.
//
//

#import <Foundation/Foundation.h>
#import "TMBaseURLDetermining.h"

/**
 Provides the default base URL for making API requests
 */
__attribute__((objc_subclassing_restricted))
@interface TMBasicBaseURLDeterminer : NSObject <TMBaseURLDetermining>

- (NSURL *)baseURL;

@end
