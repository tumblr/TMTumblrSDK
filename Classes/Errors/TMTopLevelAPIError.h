//
//  TMTopLevelAPIError.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#import "TMAPIError.h"

/**
 * Model representing the errors in the top level of an API response.
 */
__attribute__((objc_subclassing_restricted))
@interface TMTopLevelAPIError : NSObject <TMAPIError>

/**
 *  Initializes an instance of @c TMTopLevelAPIError.
 *
 *  @param logout Whether or not this error denotes whether we should log a user out.
 *  @param title  The title of the API error. Eg "Unauthorized".
 *  @param detail A more descriptive string detailing why the error is occurring.
 *  @param code   A code associated with the specific error.
 *  @param needsConsent Whether or not the error indicates that the user must go through the flow for GDPR terms.
 *  @param isConsentBlocking Whether or not the consent is required to continue using the app.
 *  @param needsAge Whether or not we need to get the user's age as part of the GDPR consent flow.
 *  @param minimumRequiredAge The specific minimum age needed for the user's country.
 *  @param authToken A token passed along for authenticating the user in some cases.
 *
 *  @return An initialized instance of @c TMTopLevelAPIError.
 */
- (nonnull instancetype)initWithLogout:(BOOL)logout title:(nonnull NSString *)title detail:(nonnull NSString *)detail code:(NSInteger)code needsConsent:(BOOL)needsConsent isConsentBlocking:(BOOL)isConsentBlocking needsAge:(BOOL)needsAge minimumRequiredAge:(NSInteger)minimumRequiredAge authToken:(NSString * _Nullable)authToken;

@end
