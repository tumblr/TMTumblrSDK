//
//  TMTopLevelAPIError.m
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import "TMTopLevelAPIError.h"

@implementation TMTopLevelAPIError
@synthesize logout = _logout;
@synthesize detail = _detail;
@synthesize title = _title;
@synthesize code = _code;
@synthesize needsConsent = _needsConsent;
@synthesize needsAge = _needsAge;
@synthesize isConsentBlocking = _isConsentBlocking;
@synthesize httpStatusCode = _httpStatusCode;

- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail code:(NSInteger)code httpStatusCode:(NSInteger)httpStatusCode needsConsent:(BOOL)needsConsent isConsentBlocking:(BOOL)isConsentBlocking needsAge:(BOOL)needsAge {
    NSParameterAssert(title);
    NSParameterAssert(detail);
    self = [super init];

    if (self) {
        _logout = logout;
        _title = title;
        _detail = detail;
        _code = code;
        _httpStatusCode = httpStatusCode;
        _needsAge = needsAge;
        _needsConsent = needsConsent;
        _isConsentBlocking = isConsentBlocking;
    }
    
    return self;
}

@end
