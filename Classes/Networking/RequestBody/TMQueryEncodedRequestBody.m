//
//  TMQueryEncodedRequestBody.m
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

#import "TMQueryEncodedRequestBody.h"
#import "TMSDKFunctions.h"

@interface TMQueryEncodedRequestBody ()

@property (nonatomic, nonnull, copy, readonly) NSDictionary *queryDictionary;

@end

@implementation TMQueryEncodedRequestBody

- (nonnull instancetype)initWithQueryDictionary:(nonnull NSDictionary *)queryDictionary {
    NSParameterAssert(queryDictionary);
    self = [super init];

    if (self) {
        _queryDictionary = [queryDictionary copy];
    }
    
    return self;
}

#pragma mark - TMRequestBody

- (nullable NSData *)bodyData {
    return [TMDictionaryToQueryString(self.queryDictionary) dataUsingEncoding:NSUTF8StringEncoding];
}

- (nullable NSString *)contentType {
    return nil;
}

- (nonnull NSDictionary *)parameters {
    return self.queryDictionary;
}

- (BOOL)encodeParameters {
    return YES;
}

@end
