//
//  TMMultipartEncodedForm.h
//  Pods
//
//  Created by Pinar Olguc on 7.05.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents an encoded multipart HTTP request body.
@interface TMMultipartEncodedForm : NSObject

/// (Optional)The encoded data which may not be available if the request body is encoded into a file.
@property (nonatomic, readonly, nullable) NSData *data;

/// The file that stores the encoded request body.
@property (nonatomic, readonly, nullable) NSURL *fileURL;

/// Initializes this `TMMultipartEncodedForm`.
/// @param fileURL The file that stores the encoded request body.
/// @param data (Optioal)The encoded data.
- (nonnull instancetype)initWithFileURL:(nonnull NSURL *)fileURL
                                   data:(nullable NSData *)data;

/// Initializes this `TMMultipartEncodedForm`. Creates a fileURL in the temp directory.
/// @param data The encoded data.
- (nonnull instancetype)initWithData:(nullable NSData *)data;

@end

NS_ASSUME_NONNULL_END
