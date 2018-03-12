//
//  TMResponseParser.h
//  Pods
//
//  Created by Kenny Ackerson on 4/26/16.
//
//

#import <Foundation/Foundation.h>

@class TMParsedHTTPResponse;

/**
 * An object that takes inputs from a URL request and produces a @c TMParsedHTTPResponse.
 */
__attribute__((objc_subclassing_restricted))
@interface TMResponseParser : NSObject

/**
 *  Initializes an object that is responsible for 
 *  
 *  1. Converting data into JSON
 *  2. Doing basic error handling (status code validation, URL response type checking)
 *  3. Constructing
 *
 *  @param data          The response's data blob.
 *  @param URLResponse   A @c NSURLResponse that comes back from the server.
 *  @param error         An error we can use if the client had any networking problems and we can pass back in the @c TMParsedHTTPResponse if appropriate.
 *  @param serializeJSON Whether or not we want to attempt to make JSON objects out of the data.
 *
 *  @return A newly initialized instance of @c TMResponseParser.
 */
- (nonnull instancetype)initWithData:(nullable NSData *)data
                         URLResponse:(nullable NSURLResponse *)URLResponse
                               error:(nullable NSError *)error
                       serializeJSON:(BOOL)serializeJSON;

/**
 *  Parses the inputs to this object and acts upon them to construct a @c TMParsedHTTPResponse.
 *
 *  @return A model object that represents a parsed HTTP response.
 */
- (nonnull TMParsedHTTPResponse *)parse;

@end
