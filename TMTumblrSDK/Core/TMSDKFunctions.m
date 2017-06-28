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
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)[string stringByReplacingOccurrencesOfString:@"+" withString:@" "],
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
    
    NSString *regexStr = @".*\\[[0-9]+\\]$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
    
    NSString *regexKeyStr = @"\\[[0-9]+\\]$";
    NSRegularExpression *replaceKeyRegex = [[NSRegularExpression alloc] initWithPattern:regexKeyStr options:NSRegularExpressionAnchorsMatchLines error:nil];

    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];

        if (keyValuePair.count == 2) {
            NSString *key = TMURLDecode(keyValuePair[0]);
            NSString *value = TMURLDecode(keyValuePair[1]);
            
            NSUInteger matches = [regex numberOfMatchesInString:key options:NSMatchingReportProgress range:NSMakeRange(0, key.length)];
            BOOL isArray = matches == 1;
            if (isArray) {
                key = [replaceKeyRegex stringByReplacingMatchesInString:key options:NSMatchingReportProgress range:NSMakeRange(0, key.length) withTemplate:@""];
            }

            id existingValueForKey = mutableParameterDictionary[key];

            if (existingValueForKey) {
                if ([existingValueForKey isKindOfClass:[NSMutableArray class]]) {
                    [(NSMutableArray *)existingValueForKey addObject:value];
                }
                else {
                    [mutableParameterDictionary setObject:[NSMutableArray arrayWithObjects:existingValueForKey, value, nil]
                                                   forKey:key];
                }
            }
            else if (isArray) {
                [mutableParameterDictionary setObject:[NSMutableArray arrayWithObject:value] forKey:key];
            }
            else {
                [mutableParameterDictionary setObject:value forKey:key];
            }
        }
    }

    return [NSDictionary dictionaryWithDictionary:mutableParameterDictionary];
}

NSString *TMDictionaryToQueryString(NSDictionary *dictionary) {
    NSMutableArray *parameters = [NSMutableArray array];

    for (NSString *key in [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
        TMAddKeyValuePairToQueryStringMutableArray(key, dictionary[key], parameters);
    }

    return [parameters componentsJoinedByString:@"&"];
}

#pragma mark - Private

void TMAddKeyValuePairToQueryStringMutableArray(NSString *key, id value, NSMutableArray *parameters) {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)value;
        for (NSString *subKey in [dictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
            TMAddKeyValuePairToQueryStringMutableArray([NSString stringWithFormat:@"%@[%@]", key, subKey], dictionary[subKey], parameters);
        }
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TMAddKeyValuePairToQueryStringMutableArray([NSString stringWithFormat:@"%@[%ld]", key, idx], obj, parameters);
        }];
    }
    else {
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", TMURLEncode(key), TMURLEncode(value)]];
    }
}

@end
