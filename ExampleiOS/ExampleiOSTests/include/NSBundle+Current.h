//
//  NSBundle+Current.h
//  
//
//  Created by Adriana Elizondo on 27/03/24.
//

#import <Foundation/Foundation.h>

@interface NSBundle (CurrentBundle)

+ (NSBundle *)currentBundleForClass:(Class)callerClass;

- (NSString *)pathForResourceInCurrentBundle:(NSString *)name ofType:(NSString *)type;

@end
