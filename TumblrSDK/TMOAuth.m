//
//  TMOAuth.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/27/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMOAuth.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <sys/sysctl.h>
#import "NSData+Base64.h"

@implementation TMOAuth

// TODO: Ensure this works without OAuthToken, OAuthTokenSecret

+ (NSString *)authorizationHeaderForRequest:(JXHTTPOperation *)request nonce:(NSString *)nonce
                                consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
                                      token:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    NSMutableDictionary *headerParameters = [[@{
        @"oauth_timestamp" : UNIXTimestamp([NSDate date]),
        @"oauth_nonce" : nonce,
        @"oauth_version" : @"1.0",
        @"oauth_signature_method" : @"HMAC-SHA1",
        @"oauth_consumer_key" : consumerKey,
        @"oauth_token" : token
    } mutableCopy] autorelease];
    
    NSMutableDictionary *signatureParameters = [NSMutableDictionary dictionaryWithDictionary:headerParameters];

    NSString *queryString = request.requestURL.query;
    
    if (queryString) {
        [signatureParameters addEntriesFromDictionary:queryStringToDictionary(queryString)];
    }
    
    // Assuming body format application/x-www-form-urlencoded
    NSDictionary *postBodyParameters = ((JXHTTPFormEncodedBody *)request.requestBody).dictionary;
    
    for (NSString *key in postBodyParameters) {
        signatureParameters[key] = URLEncode(postBodyParameters[key]);
    }
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    void (^addParameter)(NSString *key, id value) = ^(NSString *key, id value) {
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", key, URLEncode(value)]];
    };
    
    for (NSString *key in [[signatureParameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
        id value = signatureParameters[key];
        
        if ([value isKindOfClass:[NSArray class]]) {
            for (id arrayValue in (NSArray *)value) {
                addParameter(key, arrayValue);
            }
        } else {
            addParameter(key, value);
        }
    }
    
    NSString *parameterString = [parameters componentsJoinedByString:@"&"];
    
    NSURL *URL = request.requestURL;
    
    NSURL *baseURL = [[NSURL alloc] initWithScheme:URL.scheme host:URL.host path:URL.path];
    
    NSMutableString *rawSignature = [NSString stringWithFormat:@"%@&%@&%@", request.requestMethod,
                                     URLEncode([baseURL absoluteString]),
                                     URLEncode(parameterString)];
    
    // Hash the raw signature string into an encrypted signature
    NSString *keyString = [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret];
    
    // Add the encrypted signature to the header parameter dictionary
    headerParameters[@"oauth_signature"] = [HMACSHA1(rawSignature, keyString) base64EncodedString];
    
    NSMutableArray *components = [NSMutableArray array];
    
    for (NSString *key in headerParameters) {
        [components addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, URLEncode(headerParameters[key])]];
    }
    
    return [NSString stringWithFormat:@"OAuth %@", [components componentsJoinedByString:@","]];
}

#pragma mark - Convenience functions

static inline NSString *URLDecode(NSString *string) {
    return [(NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")) autorelease];
}

static inline NSString *URLEncode(NSString *string) {
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8) autorelease];
}

static inline NSString *UNIXTimestamp(NSDate *date) {
    return [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
}

static inline NSDictionary *queryStringToDictionary(NSString *query) {
    NSMutableDictionary *mutableParameterDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    
    for (NSString *parameter in parameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        
        if (keyValuePair.count != 2) {
            // TODO: Possible for a parameter to have only a key and no value?
            continue;
        }
        
        [mutableParameterDictionary setObject:URLDecode(keyValuePair[1]) forKey:URLDecode(keyValuePair[0])];
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableParameterDictionary];
}

static inline NSData *HMACSHA1(NSString *dataString, NSString *keyString) {
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *key = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    
    void *buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [data bytes], [data length], buffer);
    
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

static inline NSString *stringParameterValueForObject(NSObject *object) {
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
        
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)object stringValue];
        
    } else if ([object isKindOfClass:[NSDate class]]) {
        return UNIXTimestamp((NSDate *)object);
    }
    
    return nil;
}

@end

