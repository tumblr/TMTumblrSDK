//
//  TMAPIError.h
//  Pods
//
//  Created by Kenny Ackerson on 7/18/16.
//
//

/**
 *  A protocol representing errors that are inside of an API response.
 */
@protocol TMAPIError 

/**
 *  Whether this error means we need to log the user out.
 */
@property (nonatomic, readonly) BOOL logout;

/**
 *  The title of the API error. Eg "Unauthorized".
 */
@property (nonatomic, readonly, nonnull) NSString *title;

/**
 *  A more descriptive string detailing why the error is occurring.
 */
@property (nonatomic, readonly, nonnull) NSString *detail;

/**
 *  A specific code associated with an error.
 */
@property (nonatomic, readonly) NSInteger code;

/**
 A specific property associated with some errors for the GUCE Consent flow.
 */
@property (nonatomic, readonly) BOOL needsConsent;

/**
 A specific property associated with some errors for the GUCE Consent flow.
 */
@property (nonatomic, readonly) BOOL isConsentBlocking;

/**
 A specific property associated with some errors for the GUCE Consent flow.
 */
@property (nonatomic, readonly) BOOL needsAge;

/**
 A specific property associated with some errors for the GUCE Consent flow. This specifies the age the user must be based on their gdpr region.
 */
@property (nonatomic, readonly) NSInteger minimumRequiredAge;

/**
 Token sometimes sent to facilitate authentication with the GUCE flow. 
 */
@property (nonatomic, readonly, nullable) NSString *authToken;

@end

