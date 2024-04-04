//
//  NSBundle+Current.m
//
//
//  Created by Adriana Elizondo on 27/03/24.
//

#import "NSBundle+Current.h"

@implementation NSBundle (CurrentBundle)

+ (NSBundle *)currentBundleForClass:(Class)callerClass {
#ifdef SWIFT_PACKAGE
    NSString *path = [SWIFTPM_MODULE_BUNDLE bundlePath];
    return [NSBundle bundleWithPath:path];
#else
    return [NSBundle bundleForClass:callerClass];
#endif
}

- (NSString *)pathForResourceInCurrentBundle:(NSString *)name ofType:(NSString *)type {
#ifdef SWIFT_PACKAGE
    return [self pathForResource:[NSString stringWithFormat:@"spm_%@", name] ofType:type];
#else
    return [self pathForResource:name ofType:type];
#endif
}

@end
