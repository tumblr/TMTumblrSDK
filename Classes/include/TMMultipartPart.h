//
//  TMMultipartPart.h
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import <Foundation/Foundation.h>

// Represents a single part of a multipart form body.
__attribute__((objc_subclassing_restricted))
@interface TMMultipartPart : NSObject

/**
 *  Initializes an instance of @c TMBodyPart.
 *
 *  @param data        The main data of this body part.
 *  @param name        The name of this body part.
 *  @param fileName    The file name from where the data came from.
 *  @param contentType The content type of the data.
 *
 *  @return A new instance of @c TMBodyPart.
 */
- (nonnull instancetype)initWithData:(nonnull NSData *)data
                                name:(nonnull NSString *)name
                            fileName:(nullable NSString *)fileName
                         contentType:(nonnull NSString *)contentType;

/**
 *  Calculates the data representation of this body part.
 *
 *  @param boundary    The boundary used when constructing the prefix string in the data representation.
 *
 *  @return The data representation of this body part.
 */
- (nonnull NSData *)dataRepresentationWithBoundary:(nonnull NSString *)boundary;

@end
