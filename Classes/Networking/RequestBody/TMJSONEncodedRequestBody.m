//
//  TMJSONEncodedRequestBody.m
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import "TMJSONEncodedRequestBody.h"

@interface TMJSONEncodedRequestBody ()

@property (nonatomic, nonnull, copy, readonly) NSDictionary *JSONDictionary;

@end

@implementation TMJSONEncodedRequestBody

- (nonnull instancetype)initWithJSONDictionary:(nonnull NSDictionary *)JSONDictionary {
    NSParameterAssert(JSONDictionary);
    self = [super init];

    if (self) {
        _JSONDictionary = [JSONDictionary copy];
    }
    
    return self;
}

#pragma mark - TMRequestBody

- (nullable NSString *)contentType {
    return @"application/json";
}

- (nullable NSData *)bodyData {
    return [NSJSONSerialization dataWithJSONObject:self.JSONDictionary options:0 error:nil];
}

- (nonnull NSDictionary *)parameters {
    return self.JSONDictionary;
}

- (BOOL)encodeParameters {
    return NO;
}

@end
