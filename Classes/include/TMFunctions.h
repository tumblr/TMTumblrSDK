//
//  TMFunctions.h
//  TMTumblrSDK
//
//  Created by Ziba Rostamian on 3/1/16.
//
//

#import <Foundation/Foundation.h>

@interface TMFunctions : NSObject

/**
 *  // Take a URL's path string containing query parameters such as '/topics?version=test' and returns a dictionary of query parameters.
 *
 *  @param fullPath Fullpath that can contain query parameters.
 *
 *  @return A dictionary of query parameters
 */
NSDictionary *queryParametersFromPath(NSString *fullPath);

/**
 *  Take a URL's path string containing query parameters such as '/topics?version=test' and returns just the path.
 *
 *  @param fullPath    Fullpath that can contain query parameters.
 *  @param defaultPath Default path with no parameters.
 *
 *  @return New path from specified parameters.
 */
NSString *pathFromPathWithQueryParameters(NSString *fullPath, NSString *defaultPath);

@end
