//
//  TMTumlbrActivity.m
//  TumblrSDK
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMTumlbrActivity.h"

@implementation TMTumlbrActivity

- (NSString *)activityType {
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle {
	return @"Tumblr";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"UIActivityTumblr"];
}

@end
