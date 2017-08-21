//
//  TMAPIErrorFactory.m
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import "TMAPIErrorFactory.h"
#import "TMTopLevelAPIError.h"
#import "TMLegacyAPIError.h"

@interface TMAPIErrorFactory ()

@property (nonatomic, readonly, nonnull) NSArray <NSDictionary *> *errors;
@property (nonatomic, readonly) BOOL legacy;

@end

@implementation TMAPIErrorFactory

- (nonnull instancetype)initWithErrors:(nonnull NSArray <NSDictionary *> *)errors legacy:(BOOL)legacy {
    NSParameterAssert(errors);
    self = [super init];

    if (self) {
        _errors = errors;
        _legacy = legacy;
    }
    
    return self;
}

- (nonnull NSArray <id <TMAPIError>> *)APIErrors {
    if (!self.legacy) {
        NSMutableArray <id <TMAPIError>> *APIErrors = [[NSMutableArray alloc] init];

        for (NSDictionary *error in self.errors) {

            id title = error[@"title"];
            id detail = error[@"detail"];
            id logout = error[@"logout"];

            /**
             *  Only accept these things if they are the right type :/
             */
            if ([title isKindOfClass:[NSString class]]
                && [detail isKindOfClass:[NSString class]]
                && ([logout isKindOfClass:[NSNumber class]] || !logout)) {
                const BOOL finalLogoutValue = [logout boolValue] ?: NO;
                [APIErrors addObject:[[TMTopLevelAPIError alloc] initWithLogout:finalLogoutValue title:title detail:detail]];
            }
        }
        return APIErrors;
    }
    else {
        /**
         *  Legacy (within the `response` key)
         */
        NSMutableArray <id <TMAPIError>> *APIErrors = [[NSMutableArray alloc] init];

        for (NSDictionary *error in self.errors) {

            /**
             *  Some of these legacy errors are not the right type (jikes what a chain; checking this is how we deal with this jawn though).
             */
            if ([error isKindOfClass:[NSDictionary class]]) {

                [error enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

                    if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]]) {
                        [APIErrors addObject:[[TMLegacyAPIError alloc] initWithTitle:key detail:obj]];
                    }
                    
                }];
            }

        }
        return APIErrors;
    }

    return @[];
}

@end
