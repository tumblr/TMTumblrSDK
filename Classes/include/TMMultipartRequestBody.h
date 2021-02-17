//
//  TMMultipartRequestBody.h
//  Pods
//
//  Created by Kenny Ackerson on 5/10/16.
//
//

#import <Foundation/Foundation.h>
#import "TMRequestBody.h"

/**
 * A request body that can upload a multipart body.
 */
__attribute__((objc_subclassing_restricted))
@interface TMMultipartRequestBody : NSObject <TMRequestBody>

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

@end
