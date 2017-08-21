//
//  TMURLEncoding.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 12/4/15.
//
//

#import "TMURLEncoding.h"

@implementation TMURLEncoding

#pragma mark - NSString Encoding

+ (NSString *)encodedString:(NSString *)string
{
    if (![string length])
        return @"";
    
    NSMutableCharacterSet * URLQueryPartAllowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [URLQueryPartAllowedCharacterSet removeCharactersInString:@"&+="];
    NSString *newStr = [string stringByAddingPercentEncodingWithAllowedCharacters:URLQueryPartAllowedCharacterSet];
    
    return newStr;
}

+ (NSString *)formEncodedString:(NSString *)string
{
    if (![string length])
        return @"";
    
    return [[self encodedString:string] stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}

#pragma mark - NSDictionary Encoding

+ (NSString *)encodedDictionary:(NSDictionary *)dictionary
{
    if (![dictionary count])
        return @"";
    
    NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    NSArray *sortedKeys = [[dictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *key in sortedKeys) {
        [self encodeObject:[dictionary objectForKey:key] withKey:key andSubKey:nil intoArray:arguments];
    }
    
    return [arguments componentsJoinedByString:@"&"];
}

+ (NSString *)formEncodedDictionary:(NSDictionary *)dictionary
{
    if (![dictionary count])
        return @"";
    
    return [[self encodedDictionary:dictionary] stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}

#pragma mark - Private Methods

+ (void)encodeObject:(id)object withKey:(NSString *)key andSubKey:(NSString *)subKey intoArray:(NSMutableArray *)array
{
    if (!object || ![key length])
        return;
    
    NSString *objectKey = nil;
    
    if (subKey) {
        objectKey = [[NSString alloc] initWithFormat:@"%@[%@]", [self encodedString:key], [self encodedString:subKey]];
    }
    else {
        objectKey = [self encodedString:key];
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSArray *sortedKeys = [[object allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *insideKey in sortedKeys) {
            [self encodeObject:[object objectForKey:insideKey] withKey:objectKey andSubKey:insideKey intoArray:array];
        }
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        for (NSString *arrayObject in (NSArray *)object) {
            NSString *arrayKey = [[NSString alloc] initWithFormat:@"%@[]", objectKey];
            [self encodeObject:arrayObject withKey:arrayKey andSubKey:nil intoArray:array];
        }
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        [array addObject:[[NSString alloc] initWithFormat:@"%@=%@", objectKey, [object stringValue]]];
    }
    else {
        NSString *encodedString = [self encodedString:object];
        [array addObject:[[NSString alloc] initWithFormat:@"%@=%@", objectKey, encodedString]];
    }
}

@end
