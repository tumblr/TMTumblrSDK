//
//  TMTumblrActivity.m
//  TumblrAppClient
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMTumblrActivity.h"

@implementation TMTumblrActivity

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (NSString *)activityType {
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle {
	return @"Tumblr";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"UIActivityTumblr"];
}

#ifdef __IPHONE_7_0
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}
#endif

@end
