//
//  TMSDKFunctions.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 3/24/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMSDKFunctions.h"

@implementation TMSDKFunctions

NSString *TMURLDecode(NSString *string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string,
                                                                                    CFSTR("")));
}

NSString *TMURLEncode(id value) {
    NSString *string;
    
    if ([value isKindOfClass:[NSString class]])
        string = (NSString *)value;
    else
        string = [value stringValue];
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8));
}

NSDictionary *TMQueryStringToDictionary(NSString *query) {
    NSMutableDictionary *mutableParameterDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    
    for (NSString *parameter in parameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        
        if (keyValuePair.count == 2) {
            NSString *key = TMURLDecode(keyValuePair[0]);
            NSString *value = TMURLDecode(keyValuePair[1]);
            
            id existingValueForKey = mutableParameterDictionary[key];
            
            if (existingValueForKey) {
                if ([existingValueForKey isKindOfClass:[NSMutableArray class]])
                    // If we already have multiple values for this key, just add another
                    [(NSMutableArray *)existingValueForKey addObject:value];
                    
                else
                    // Create a new mutable array with the existing value and the new value
                    [mutableParameterDictionary setObject:[NSMutableArray arrayWithObjects:existingValueForKey, value, nil]
                                                   forKey:key];
            } else
                [mutableParameterDictionary setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableParameterDictionary];
}

NSString *TMDictionaryToQueryString(NSDictionary *dictionary) {
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (NSString *key in [dictionary allKeys])
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", TMURLEncode(key), TMURLEncode(dictionary[key])]];
    
    return [parameters componentsJoinedByString:@"&"];
}

@end
