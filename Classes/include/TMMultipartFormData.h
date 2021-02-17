//
//  TMMultipartFormData.h
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import <Foundation/Foundation.h>

@class TMMultipartPart;

// Represents a multipart form encoded HTTP body.
__attribute__((objc_subclassing_restricted))
@interface TMMultipartFormData : NSObject

/**
 *  Initializes an instance of @c TMMultipartFormData.
 *
 *  @param parts       The parts of this multipart form request body.
 *  @param boundary    The boundary used after the parts are added to the data representation.
 *
 *  @return A newly initialized instance of @c TMMultipartFormData
 */
- (nonnull instancetype)initWithParts:(nonnull NSArray <TMMultipartPart *> *)parts boundary:(nonnull NSString *)boundary;

/**
 *  Calculates the data representation of this multipart form.
 *
 *  @return The data representation of this multipart form.
 */
- (nonnull NSData *)dataRepresentation;

@end
