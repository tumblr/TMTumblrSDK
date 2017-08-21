//
//  TMBasicBaseURLDeterminer.m
//  Pods
//
//  Created by Tyler Tape on 6/1/17.
//
//

#import "TMBasicBaseURLDeterminer.h"

@implementation TMBasicBaseURLDeterminer

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://api.tumblr.com/v2/"];
}

@end
