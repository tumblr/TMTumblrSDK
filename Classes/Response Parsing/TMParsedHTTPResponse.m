//
//  TMParsedHTTPResponse.m
//  Pods
//
//  Created by Kenny Ackerson on 4/26/16.
//
//

#import "TMParsedHTTPResponse.h"

@implementation TMParsedHTTPResponse

- (nonnull instancetype)initWithJSONDictionary:(nullable NSDictionary<NSString *, id> *)JSONDictionary
                                    successful:(BOOL)successful
                           responseDescription:(nullable NSString *)responseDescription
                                         error:(nullable NSError *)error
                                     APIErrors:(nonnull NSArray <id <TMAPIError>> *)APIErrors
                                    statusCode:(NSInteger)statusCode {
    self = [super init];

    if (self) {
        _JSONDictionary = [JSONDictionary copy];
        _successful = successful;
        _responseDescription = [responseDescription copy];
        _APIErrors = [APIErrors copy];
        _error = error;
        _statusCode = statusCode;
    }
    
    return self;
}

@end
