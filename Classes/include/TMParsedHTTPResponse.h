//
//  TMParsedHTTPResponse.h
//  Pods
//
//  Created by Kenny Ackerson on 4/26/16.
//
//

#import <Foundation/Foundation.h>

@protocol TMAPIError;

/**
 * A model object representing a HTTP response from the Tumblr API.
 */
__attribute__((objc_subclassing_restricted))
@interface TMParsedHTTPResponse : NSObject

/**
 *  Constructs the @c TMParsedHTTPResponse object.
 *
 *  @param JSONDictionary      The dictionary of the JSON returned from the API.
 *  @param successful          Whether or not the HTTP requst was successful or not.
 *  @param responseDescription The description string of the URL response.
 *  @param error               An optional error if something went wrong.
 *  @param APIErrors           An array of errors that were in the response's body.
 *  @param statusCode          The HTTP status code of the request.
 *
 *  @return A new model that represents a HTTP response from the API.
 */
- (nonnull instancetype)initWithJSONDictionary:(nullable NSDictionary<NSString *, id> *)JSONDictionary
                                    successful:(BOOL)successful
                           responseDescription:(nullable NSString *)responseDescription
                                         error:(nullable NSError *)error
                                     APIErrors:(nonnull NSArray <id <TMAPIError>> *)APIErrors
                                    statusCode:(NSInteger)statusCode;

/**
 *  The dictionary of the JSON returned from the API.
 */
@property (nonatomic, nullable, copy, readonly) NSDictionary<NSString *, id> *JSONDictionary;

/**
 *  Whether or not the HTTP requst was successful or not.
 */
@property (nonatomic, readonly) BOOL successful;

/**
 *  The description string of the URL response.
 */
@property (nonatomic, nullable, copy, readonly) NSString *responseDescription;

/**
 *  An optional error if something went wrong.
 */
@property (nonatomic, nullable, readonly) NSError *error;

/**
 *  An array of errors that were in the response's body.
 */
@property (nonatomic, nonnull, copy, readonly) NSArray <id <TMAPIError>> *APIErrors;

/**
 *  The HTTP status code of the request.
 */
@property (nonatomic, readonly) NSInteger statusCode;

@end
