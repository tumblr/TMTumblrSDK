//
//  TMEncodableMultipartFormData.h
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import <Foundation/Foundation.h>
#import "TMMultipartPart.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const TMMultipartFormErrorDomain;

typedef NS_ENUM(NSInteger, TMMultipartFormErrorType) {
    TMMultipartFormErrorTypeFileNameNotValid = 100,
    TMMultipartFormErrorTypeURLNotUsingFileScheme,
    TMMultipartFormErrorTypeFileNotReachable,
    TMMultipartFormErrorTypeFileIsDirectory,
    TMMultipartFormErrorTypeFileSizeNotAvailable,
    TMMultipartFormErrorTypeInputStreamCreationFailed,
    TMMultipartFormErrorTypeOutputFileAlreadyExists,
    TMMultipartFormErrorTypeOutputFileURLInvalid,
    TMMultipartFormErrorTypeOutputStreamCreationFailed,
    TMMultipartFormErrorTypeOutputStreamWriteFailed,
    TMMultipartFormErrorTypeInputStreamReadFailed,
    TMMultipartFormErrorTypeEncodingFailed,
    TMMultipartFormErrorTypeInvalidFilePath,
    TMMultipartFormErrorTypeUnexpectedInputLength
};

/// Creates `multipart/form-data` for uploads. Provides 2 separate ways to encode the parts.
/// 1. `encodeIntoFileWithURL:` encodes into a file. This is the memory efficient way.
/// 2. `encodeIntoDataWithError:` encodes into an NSData instance. This is faster, but leads to fatal memory issues if the data is large enough.
/// The caller party should decide between the 2 according to circumstances. But it is highly recommended that if there are large files involved like videos(>10mb) go with option 2. (Remember, the memory budget of the Share extension is a lot less than the main app.)
@interface TMEncodableMultipartFormData : TMMultipartPart

/// Total length of the parts in bytes.
@property (nonatomic, readonly) UInt64 totalContentLength;

/// Initializes this `TMEncodableMultipartFormData`
/// @param fileManager NSFileManager instance to use when encoding the parts into a file.
/// @param boundary Boundary string to inject.
- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager boundary:(nonnull NSString *)boundary;

/// Appends the given data object to the parts. Format:
///
/// --{Boundary}
/// Content-Disposition: form-data; name=#{name}; filename=#{filename}
/// Content-Type: #{contentType}
/// - Encoded data
///
/// @param data Data to add.
/// @param name  `name` attribute value from `Content-Disposition` header.
/// @param fileName (optional) `filename` attribute value from `Content-Disposition` header.
/// @param contentType `Content-Type` header value.
- (void)appendData:(nonnull NSData *)data
              name:(nonnull NSString *)name
          fileName:(nullable NSString *)fileName
       contentType:(nonnull NSString *)contentType;


/// Appends the data read from the given input stream to the parts. Format:
///
/// --{Boundary}
/// Content-Disposition: form-data; name=#{name}; filename=#{filename}
/// Content-Type: #{contentType}
/// - Encoded data
///
/// @param inputStream NSInputStream instance to get the input data.
/// @param contentLength Content length in bytes of the input stream.
/// @param name  `name` attribute value from `Content-Disposition` header.
/// @param fileName (optional) `filename` attribute value from `Content-Disposition` header.
/// @param contentType `Content-Type` header value.
- (void)appendInputStream:(nonnull NSInputStream *)inputStream
            contentLength:(UInt64)contentLength
                     name:(nonnull NSString *)name
                 fileName:(nullable NSString *)fileName
              contentType:(nonnull NSString *)contentType;

/// Appends the data read from the given input stream to the parts. Format:
///
/// --{Boundary}
/// Content-Disposition: form-data; name=#{name}; filename=#{generated filename}
/// Content-Type: #{contentType}
/// - Encoded data
///
/// @param fileURL The URL whose contents will be added.
/// @param name  `name` attribute value from `Content-Disposition` header.
/// @param contentType `Content-Type` header value.
/// @param error Any error that is generated during file handling. Error codes are of type `TMMultipartFormErrorType`.
- (void)appendFileURL:(nonnull NSURL *)fileURL
                 name:(nonnull NSString *)name
          contentType:(nonnull NSString *)contentType
                error:(NSError **)error;

/// Appends the data read from the given input stream to the parts. Format:
///
/// --{Boundary}
/// Content-Disposition: form-data; name=#{name}; filename=#{generated filename}
/// Content-Type: #{contentType}
/// - Encoded data
///
/// @param filePath The path whose contents will be added.
/// @param name  `name` attribute value from `Content-Disposition` header.
/// @param contentType `Content-Type` header value.
/// @param error Any error encountered. Check out `TMMultipartFormErrorType`.
- (void)appendFilePath:(NSString *)filePath
                  name:(nonnull NSString *)name
           contentType:(nonnull NSString *)contentType
                 error:(NSError **)error;

/// Encodes all appended body parts into a file in the temp directory. This
/// @param fileURL URL to write form data into.
/// @param error Any error encountered. Check out `TMMultipartFormErrorType`.
- (void)encodeIntoFileWithURL:(NSURL *)fileURL error:(NSError **)error;

/// Encodes all appended body parts into an NSData instance. This method puts all the parts into memory so it can lead to fatal memory issues if the data is large.
/// So, use  `encodeIntoFileWithURL:` instead for large files(>10MB) like videos.
/// @param error Any error encountered. Check out `TMMultipartFormErrorType`.
- (NSData *)encodeIntoDataWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
