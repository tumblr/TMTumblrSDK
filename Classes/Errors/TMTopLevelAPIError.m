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
@synthesize minimumRequiredAge = _minimumRequiredAge;
@synthesize isConsentBlocking = _isConsentBlocking;
@synthesize authToken = _authToken;

- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail code:(NSInteger)code needsConsent:(BOOL)needsConsent isConsentBlocking:(BOOL)isConsentBlocking needsAge:(BOOL)needsAge minimumRequiredAge:(NSInteger)minimumRequiredAge authToken:(NSString * _Nullable)authToken {
    NSParameterAssert(title);
    NSParameterAssert(detail);
    self = [super init];

    if (self) {
        _logout = logout;
        _title = title;
        _detail = detail;
        _code = code;
        _needsAge = needsAge;
        _minimumRequiredAge = minimumRequiredAge;
        _needsConsent = needsConsent;
        _isConsentBlocking = isConsentBlocking;
        _authToken = authToken;
    }
    
    return self;
}

@end
