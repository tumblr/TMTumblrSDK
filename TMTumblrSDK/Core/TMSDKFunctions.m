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
                                                                                 CFSTR("!*'();:@&=+$,[]/?%#%"), kCFStringEncodingUTF8));
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
                    [(NSMutableArray *)existingValueForKey addObject:value];
                else
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
    
    for (NSString *key in [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
        AddParameter(key, dictionary[key], parameters);
    }
    
    return [parameters componentsJoinedByString:@"&"];
}

#pragma mark - private

void AddParameter(NSString *key, id value, NSMutableArray *parameters) {
    if ([value isKindOfClass:[NSDictionary class]]) {
        for (NSString *subKey in [((NSDictionary *)value).allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
            AddParameter([NSString stringWithFormat:@"%@[%@]", key, subKey], value[subKey], parameters);
        }
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        for (id arrayValue in (NSArray *)value){
            AddParameter(key, arrayValue, parameters);
        }
    }
    else {
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", TMURLEncode(key), TMURLEncode(value)]];
    }
}

@end
