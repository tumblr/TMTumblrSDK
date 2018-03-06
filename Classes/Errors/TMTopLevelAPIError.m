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

- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail code:(NSInteger)code {
    NSParameterAssert(title);
    NSParameterAssert(detail);
    self = [super init];

    if (self) {
        _logout = logout;
        _title = title;
        _detail = detail;
        _code = code;
    }
    
    return self;
}

@end
