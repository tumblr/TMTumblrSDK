//
//  TMEncodableMultipartFormData.h
//  TMTumblrSDK
//
//  Created by Pinar Olguc on 5.05.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const TMMultipartFormErrorDomain;

typedef enum{
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
    TMMultipartFormErrorTypeEncodingFailed
}TMMultipartFormErrorType;

@interface TMEncodableMultipartFormData : NSObject

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager boundary:(nonnull NSString *)boundary;

- (void)appendData:(nonnull NSData *)data
              name:(nonnull NSString *)name
          fileName:(nullable NSString *)fileName
       contentType:(nonnull NSString *)contentType;

- (void)appendInputStream:(nonnull NSInputStream *)inputStream
            contentLength:(UInt64)contentLength
                     name:(nonnull NSString *)name
                 fileName:(nullable NSString *)fileName
              contentType:(nonnull NSString *)contentType;

- (void)appendFileURL:(nonnull NSURL *)fileURL
                 name:(nonnull NSString *)name
          contentType:(nonnull NSString *)contentType
                error:(NSError **)error;

- (void)writePartsToFileURL:(NSURL *)fileURL error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
