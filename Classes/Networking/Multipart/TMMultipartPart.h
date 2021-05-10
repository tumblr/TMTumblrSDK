//
//  TMMultipartPart.h
//  Pods
//
//  Created by Kenny Ackerson on 4/23/16.
//
//

#import <Foundation/Foundation.h>
#import "TMMultipartPartProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMMultipartPart : NSObject <TMMultipartPartProtocol>

@property (nonatomic, nonnull, copy, readonly) NSString *name;
@property (nonatomic, nullable, copy, readonly) NSString *fileName;
@property (nonatomic, nonnull, copy, readonly) NSString *contentType;
@property (nonatomic, readonly) UInt64 contentLength;

/**
 *  Initializes an instance of @c TMMultipartPart.
 *
 *  @param name        The name of this body part.
 *  @param fileName    The file name from where the data came from.
 *  @param contentType The content type of the data.
 *  @param contentLength The size of the content in bytes.
 *
 *  @return A new instance of @c TMMultipartPart.
 */
- (nonnull instancetype)initWithName:(nonnull NSString *)name
                            fileName:(nullable NSString *)fileName
                         contentType:(nonnull NSString *)contentType
                       contentLength:(UInt64)contentLength;

@end

NS_ASSUME_NONNULL_END
