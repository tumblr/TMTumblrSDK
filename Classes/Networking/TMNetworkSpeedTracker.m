//
//  TMNetworkSpeedTracker.m
//  Pods
//
//  Created by Kenny Ackerson on 8/1/17.
//
//

#import "TMNetworkSpeedTracker.h"
#import "os/lock.h"

os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
short samples = 0;

@implementation TMNetworkSpeedTracker

+ (NSMutableArray *)sharedArray {
    static dispatch_once_t once;
    static NSMutableArray *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

- (void)track:(NSDate *)start endDate:(NSDate *)end bytes:(long long)bytes {
    if (bytes >= 1024) {
        const NSTimeInterval timeDifference = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate;

        if (timeDifference > 0) {
            const double bytesPerSecond = bytes / timeDifference;
            const NSNumber *kbps = @(bytesPerSecond * 0.008);

            const id class = [self class];

            os_unfair_lock_lock(&lock);

            NSMutableArray *numbers = [class sharedArray];

            if (numbers.count > 10) {
                numbers[0] = kbps;
            }
            else {
                [numbers addObject:kbps];
            }

            samples++;
            
            os_unfair_lock_unlock(&lock);
        }
    }
}

+ (TMNetworkSpeedQuality)quality {
    const double kbps = [self kbps];

    const float low = 150;
    const float medium = 550;
    const float high = 2000;

    if (kbps <= low) {
        return TMNetworkSpeedQualityBad;
    }
    else if (kbps <= medium) {
        return TMNetworkSpeedQualityModerate;
    }
    else if (kbps <= high) {
        return TMNetworkSpeedQualityGood;
    }

    return TMNetworkSpeedQualityUnkown;
}

+ (double)kbps {
    os_unfair_lock_lock(&lock);

    // Make a copy of this so we can iterate through it outside the lock
    NSArray *copy = [[[self class] sharedArray] copy];
    os_unfair_lock_unlock(&lock);

    double total = 0;
    for (NSNumber *number in copy) {
        total += [number doubleValue];
    }

    return total / copy.count;
}

@end
