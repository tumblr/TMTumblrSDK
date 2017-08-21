//
//  TMRequestMethodHelpers.m
//  Pods
//
//  Created by Kenny Ackerson on 6/17/16.
//
//

#import "TMRequestMethodHelpers.h"

@implementation TMRequestMethodHelpers

+ (TMHTTPRequestMethod)methodFromString:(nonnull NSString *)methodString {
    if ([methodString isEqualToString:@"GET"]) {
        return TMHTTPRequestMethodGET;
    }
    else if ([methodString isEqualToString:@"POST"]) {
        return TMHTTPRequestMethodPOST;
    }
    else if ([methodString isEqualToString:@"DELETE"]) {
        return TMHTTPRequestMethodDELETE;
    }
    else if ([methodString isEqualToString:@"PUT"]) {
        return TMHTTPRequestMethodPUT;
    }
    else if ([methodString isEqualToString:@"HEAD"]) {
        return TMHTTPRequestMethodHEAD;
    }

    return TMHTTPRequestMethodGET;
}

+ (nonnull NSString *)stringFromMethod:(TMHTTPRequestMethod)method {
    switch (method) {
        case TMHTTPRequestMethodGET:
            return @"GET";
        case TMHTTPRequestMethodPOST:
            return @"POST";
        case TMHTTPRequestMethodDELETE:
            return @"DELETE";
        case TMHTTPRequestMethodPUT:
            return @"PUT";
        case TMHTTPRequestMethodHEAD:
            return @"HEAD";
    }
}

@end
