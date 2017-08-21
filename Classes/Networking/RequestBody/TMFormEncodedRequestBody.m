//
//  TMFormEncodedRequestBody.m
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import "TMFormEncodedRequestBody.h"
#import "TMURLEncoding.h"

@interface TMFormEncodedRequestBody ()

@property (nonatomic, nonnull, copy, readonly) NSDictionary *body;

@end

@implementation TMFormEncodedRequestBody

- (nonnull instancetype)initWithBody:(nonnull NSDictionary *)body {
    NSParameterAssert(body);
    self = [super init];

    if (self) {
        _body = [body copy];
    }
    
    return self;
}

#pragma mark - TMRequestBody

- (nullable NSData *)bodyData {
    return [[TMURLEncoding formEncodedDictionary:self.body] dataUsingEncoding:NSUTF8StringEncoding];
}

- (nullable NSString *)contentType {
    return @"application/x-www-form-urlencoded; charset=utf-8";
}

- (nonnull NSDictionary *)parameters {
    return self.body;
}

- (BOOL)encodeParameters {
    return YES;
}

@end
