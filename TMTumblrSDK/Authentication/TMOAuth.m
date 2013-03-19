//
//  TMOAuth.m
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

#import "TMOAuth.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <sys/sysctl.h>
#import "NSData+Base64.h"

@implementation TMOAuth

+ (NSString *)headerForURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
                     nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
                     token:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    TMOAuth *auth = [[TMOAuth alloc] initWithURL:URL method:method postParameters:postParameters nonce:nonce
                                     consumerKey:consumerKey consumerSecret:consumerSecret token:token tokenSecret:tokenSecret];
    return auth.headerString;
}

- (id)initWithURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
            nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
            token:(NSString *)token tokenSecret:(NSString *)tokenSecret {
    if (self = [super init]) {
        NSMutableDictionary *headerParameters = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                 @"oauth_timestamp" : UNIXTimestamp([NSDate date]),
                                                 @"oauth_nonce" : nonce,
                                                 @"oauth_version" : @"1.0",
                                                 @"oauth_signature_method" : @"HMAC-SHA1",
                                                 @"oauth_consumer_key" : consumerKey,
                                                 }];
        
        if (token && token.length > 0)
            headerParameters[@"oauth_token"] = token;
        
        NSDictionary *queryParameters = queryStringToDictionary(URL.query);
        
        NSString *baseURLString = [[URL absoluteString] componentsSeparatedByString:@"?"][0];
        
        NSString *baseString = generateBaseString(baseURLString, method, headerParameters, queryParameters, postParameters);
        
        _baseString = baseString;
        
        headerParameters[@"oauth_signature"] = sign(baseString, consumerSecret, tokenSecret);
        
        NSMutableArray *components = [NSMutableArray array];
        
        for (NSString *key in headerParameters)
            [components addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, URLEncode(headerParameters[key])]];
        
        _headerString = [NSString stringWithFormat:@"OAuth %@", [components componentsJoinedByString:@","]];
    }
    
    return self;
}

#pragma mark - Private

static inline NSString *generateBaseString(NSString *baseURL, NSString *method, NSDictionary *headers,
                                           NSDictionary *queryParameters, NSDictionary *postParameters) {
    NSMutableDictionary *signatureParameters = [NSMutableDictionary dictionaryWithDictionary:headers];
    [signatureParameters addEntriesFromDictionary:queryParameters];
    [signatureParameters addEntriesFromDictionary:postParameters];
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (NSString *key in [[signatureParameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)])
        [parameters addObject:[NSString stringWithFormat:@"%@=%@", key, URLEncode(signatureParameters[key])]];
    
    NSString *parameterString = URLEncode([parameters componentsJoinedByString:@"&"]);
    
    return [NSString stringWithFormat:@"%@&%@&%@", method, URLEncode(baseURL), parameterString];
}

static inline NSString *sign(NSString *baseString, NSString *consumerSecret, NSString *tokenSecret) {
    NSString *keyString = [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret ? tokenSecret : @""];
    
    return [HMACSHA1(baseString, keyString) base64EncodedString];
}

static inline NSString *URLDecode(NSString *string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)string, CFSTR("")));
}

static inline NSString *URLEncode(id value) {
    NSString *string;
    
    if ([value isKindOfClass:[NSString class]])
        string = (NSString *)value;
    else
        string = [value stringValue];
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]%"),
                                                                                 kCFStringEncodingUTF8));
}

static inline NSString *UNIXTimestamp(NSDate *date) {
    return [NSString stringWithFormat:@"%f", round([date timeIntervalSince1970])];
}

static inline NSDictionary *queryStringToDictionary(NSString *query) {
    NSMutableDictionary *mutableParameterDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    
    for (NSString *parameter in parameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        
        if (keyValuePair.count != 2)
            continue;
        
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

@end
