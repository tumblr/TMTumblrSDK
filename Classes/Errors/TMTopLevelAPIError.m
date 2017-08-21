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

- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail {
    NSParameterAssert(title);
    NSParameterAssert(detail);
    self = [super init];

    if (self) {
        _logout = logout;
        _title = title;
        _detail = detail;
    }
    
    return self;
}

@end
