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
            id code = error[@"code"];
            id needsConsent = error[@"gdpr_needs_consent"];
            id isConsentBlocking = error[@"gdpr_is_consent_blocking"];
            id needsAge = error[@"gdpr_needs_age"];
            id authToken = error[@"gdpr_auth_token"];
            id minimumRequiredAge = error[@"gdpr_minimum_required_age"];
            id consentProvider = error[@"consent_provider"];

            /**
             *  Only accept these things if they are the right type :/
             */
            if ([title isKindOfClass:[NSString class]]
                && [detail isKindOfClass:[NSString class]]
                && ([logout isKindOfClass:[NSNumber class]] || !logout)
                && ([code isKindOfClass:[NSNumber class]] || !code)
                && ([authToken isKindOfClass:[NSString class]] || !authToken)
                && ([minimumRequiredAge isKindOfClass:[NSNumber class]] || !minimumRequiredAge)) {
                const BOOL finalLogoutValue = [logout boolValue] ?: NO;
                const BOOL finalNeedsConsentValue = [needsConsent boolValue] ?: NO;
                const BOOL finalIsConsentBockingValue = [isConsentBlocking boolValue] ?: NO;
                const BOOL finalNeedsAgeValue = [needsAge boolValue] ?: NO;

                const NSInteger finalCodeValue = [code integerValue];
                const NSInteger finalMinimumRequiredAgeValue = [minimumRequiredAge integerValue];

                [APIErrors addObject:[[TMTopLevelAPIError alloc] initWithLogout:finalLogoutValue title:title detail:detail code:finalCodeValue needsConsent:finalNeedsConsentValue  isConsentBlocking:finalIsConsentBockingValue needsAge:finalNeedsAgeValue minimumRequiredAge:finalMinimumRequiredAgeValue consentProvider:consentProvider authToken:authToken]];
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
}

@end
