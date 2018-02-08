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
const short targetSampleSize = 10;

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
    if (bytes >= 10240) {
        const NSTimeInterval timeDifference = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate;

        if (timeDifference > 0.001) {
            const double bytesPerSecond = bytes / timeDifference;
            NSNumber * const kbps = @(bytesPerSecond * 0.008);
            const id class = [self class];

            os_unfair_lock_lock(&lock);
            [class addTrackedSpeed:kbps toSpeeds:[class sharedArray]];
            os_unfair_lock_unlock(&lock);
        }
    }
}

+ (TMNetworkSpeedQuality)quality {
    const double kbps = [self kbps];
    const short bad = 150;
    const short moderate = 550;
    const short good = 2000;

    if (kbps <= 0) {
        return TMNetworkSpeedQualityUnkown;
    }
    else if (kbps <= bad) {
        return TMNetworkSpeedQualityBad;
    }
    else if (kbps <= moderate) {
        return TMNetworkSpeedQualityModerate;
    }
    else if (kbps <= good) {
        return TMNetworkSpeedQualityGood;
    }
    else {
        return TMNetworkSpeedQualityExcellent;
    }
}

+ (double)kbps {
    os_unfair_lock_lock(&lock);
    // Make a copy of this so we can iterate through it outside the lock
    NSArray *copy = [[[self class] sharedArray] copy];

    if (copy.count < targetSampleSize) {
        os_unfair_lock_unlock(&lock);
        return -1;
    }
    os_unfair_lock_unlock(&lock);

    double total = 0;
    for (NSNumber *number in copy) {
        total += [number doubleValue];
    }

    return total / copy.count;
}

+ (void)addTrackedSpeed:(NSNumber *)kbps toSpeeds:(NSMutableArray *)speeds {
    [speeds addObject:kbps];
    // Keeps the sample size capped to monitor the most recent samples taken
    if (speeds.count > targetSampleSize) {
        [speeds removeObjectAtIndex:0];
    }
}

@end

