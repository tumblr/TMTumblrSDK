//
//  TMFunctions.m
//  TMTumblrSDK
//
//  Created by Ziba Rostamian on 3/1/16.
//
//

#import "TMFunctions.h"
#import "TMSDKFunctions.h"

@implementation TMFunctions

// Take a URL's path string containing query parameters such as '/topics?version=test' and returns a dictionary of query parameters.
NSDictionary *queryParametersFromPath(NSString *fullPath) {
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    
    if (fullPath) {
        NSArray *pathAndQueryStrings = [fullPath componentsSeparatedByString:@"?"];
        // Splitting on the '?' should yield exactly 2 components if any query parameters exist.
        if (pathAndQueryStrings.count == 2) {
            // Take the second component e.g. "version=test&type=test" and parse that.
            NSString *rawQueryParametersString = pathAndQueryStrings[1];
            [queryParameters addEntriesFromDictionary:TMQueryStringToDictionary(rawQueryParametersString)];
        }
    }
    
    return queryParameters;
}

// Take a URL's path string containing query parameters such as '/topics?version=test' and returns just the path.
NSString *pathFromPathWithQueryParameters(NSString *fullPath, NSString *defaultPath) {
    NSString *requestPath = defaultPath;
    
    if (fullPath) {
        NSArray *pathAndQueryStrings = [fullPath componentsSeparatedByString:@"?"];
        // Splitting on the "?" should yield at least one component and we assume the first is the path.
        if (pathAndQueryStrings.count >= 1) {
            requestPath = pathAndQueryStrings[0];
        }
    }
    
    return requestPath;
}

@end
