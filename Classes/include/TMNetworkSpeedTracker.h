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

/**
 * Add a tracked network event to the pool of network speed samples
 *
 * - param track: NSDate for the start of the network request
 * - param endDate: NSDate for the end of the request, after the response is received
 * - param bytes: Size of the request in bytes
 */
- (void)track:(NSDate *)start endDate:(NSDate *)end bytes:(long long)bytes;


/// Raw kilobytes per second representing the network speed
+ (double)kbps;

/**
 * Generalized quality of the network speed. If an unknown network speed quality
 * is returned, the sample size is too small to provide an adequate judge of
 * network speed.
 */
+ (TMNetworkSpeedQuality)quality;

@end

