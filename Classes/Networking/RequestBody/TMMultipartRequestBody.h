//
//  TMMultipartRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 5/10/16.
//
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"
#import "TMEncodableMultipartFormData.h"
#import "TMMultipartEncodedForm.h"
#import "TMMultiPartRequestBodyProtocol.h"

extern UInt64 const TMMultipartFormFileEncodingThreshold;

NS_ASSUME_NONNULL_BEGIN

/**
 * A request body that can upload a multipart body.
 */
__attribute__((objc_subclassing_restricted))
@interface TMMultipartRequestBody : NSObject <TMMultiPartRequestBodyProtocol>

/**
 *  Initializes a request body that can upload a multipart body.
 *
 *  @warning The file paths passed into here MUST be able to be reached, or this will throw an exception.
 *
 *  @param filePaths    The file paths of the files to upload.
 *  @param contentTypes The content types of each of the files to upload.
 *  @param fileNames    The names of the files we want to upload.
 *  @param parameters   The post parameters for the request.
 *  @param keys         The keys for each of the files. ex (@[@"data", @"data"]) for two files.
 *
 *  @return A new request body for uploading multipart data.
 */
- (nonnull instancetype)initWithFilePaths:(nonnull NSArray<NSString *> *)filePaths
                             contentTypes:(nonnull NSArray<NSString *> *)contentTypes
                                fileNames:(nonnull NSArray<NSString *> *)fileNames
                               parameters:(nonnull NSDictionary *)parameters
                                     keys:(nonnull NSArray <NSString *> *)keys
                           encodeJSONBody:(BOOL)encodeJSONBody;


/// Initializes a request body that can upload a multipart body.
/// @param filePaths The file paths of the files to upload.
/// @param contentTypes The content types of each of the files to upload.
/// @param fileNames  The names of the files we want to upload.
/// @param parameters  The post parameters for the request.
/// @param keys  The keys for each of the files. ex (@[@"data", @"data"]) for two files.
/// @param encodeJSONBody Boolean that tells if we should serialize the parameters in json format.
/// @param fileEncodingThreshold  The threshold to decide whether we should encode as a file or data.
- (nonnull instancetype)initWithFilePaths:(nonnull NSArray<NSString *> *)filePaths
                             contentTypes:(nonnull NSArray<NSString *> *)contentTypes
                                fileNames:(nonnull NSArray<NSString *> *)fileNames
                               parameters:(nonnull NSDictionary *)parameters
                                     keys:(nonnull NSArray <NSString *> *)keys
                           encodeJSONBody:(BOOL)encodeJSONBody
                    fileEncodingThreshold:(UInt64)fileEncodingThreshold;

/// Encodes the request body. If the contents are below the `fileEncodingThreshold`,
/// encoded data will be returned as NSData, otherwise as a temp file pointed by `fileURL` inside the response of type `TMMultipartEncodedForm`.
/// The `fileEncodingThreshold` equals to 10MB by default unless TMMultipartRequestBody is initialized with a custom value.
/// @param error Encoding error.
- (nullable TMMultipartEncodedForm *)encodeWithError:(NSError **)error;

/// Encodes the multipart data into a file and returns its URL.
/// @param error Encoding error.
- (nullable NSURL *)encodeIntoFileWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
