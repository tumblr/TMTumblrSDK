//
//  TMRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 4/25/16.
//
//

/**
 *  Model object that represents an HTTP body.
 */
@protocol TMRequestBody

/**
 *  Calculates the data in the HTTP body.
 *
 *  @return The data in the HTTP body.
 */
- (nullable NSData *)bodyData;

/**
 *  Gets the content type for the header of Content-Type on a request.
 *
 *  @return The content type of the request body.
 */
- (nullable NSString *)contentType;

/**
 *  The parameters represented by the body data.
 *
 *  @return Parameters that are represented by the body data.
 */
- (nonnull NSDictionary *)parameters;

/**
 *  Whether or not we should encode the parameters when creating the authorization hash.
 *  OAuth requires GET and POST parameters to be included when calculating authorization, 
 *  but if the parameters are data inside of the request body (JSON for example), then we 
 *  should not include them.
 *
 *  @return Whether or not we should encode the parameters when creating the authorization hash.
 */
- (BOOL)encodeParameters;

@end
