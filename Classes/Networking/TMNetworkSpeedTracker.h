//
//  TMNetworkSpeedTracker.h
//  Pods
//
//  Created by Kenny Ackerson on 8/1/17.
//
//

#import <Foundation/Foundation.h>
#import "TMNetworkSpeedQuality.h"

@interface TMNetworkSpeedTracker : NSObject

- (void)track:(NSDate *)start endDate:(NSDate *)end bytes:(long long)bytes;

+ (double)kbps;

+ (TMNetworkSpeedQuality)quality;

@end
