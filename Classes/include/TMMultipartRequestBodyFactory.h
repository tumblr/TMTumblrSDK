//
//  TMMultipartRequestBodyFactory.h
//  Pods
//
//  Created by Kenny Ackerson on 5/16/16.
//
//

#import <Foundation/Foundation.h>

@protocol TMRequestBody;

/**
 *  A Factory-type class to create request bodies that represent multipart request bodies.
 */
__attribute__((objc_subclassing_restricted))
@interface TMMultipartRequestBodyFactory : NSObject

/**
 *  Class method for creating a request body that holds multipart request data
 *
 *  @param parameters           The post parameters for the request.
 *  @param filePathArray        The file paths of the files to upload.
 *  @param contentTypeArray     The content types of each of the files to upload.
 *  @param fileNameArray        The names of the files we want to upload.
 *  @param type                 The type of multipart request this is (eg "photo" for photo posts)
 *  @param keys                 The keys for each of the files. ex (@[@"data", @"data"]) for two files.
 *
 *  @return A new request body that is a multipart request body.
 */
+ (nonnull id <TMRequestBody>)multipartRequestBodyForParameters:(nullable NSDictionary *)parameters
                                                  filePathArray:(nonnull NSArray *)filePathArray
                                               contentTypeArray:(nonnull NSArray *)contentTypeArray
                                                  fileNameArray:(nonnull NSArray *)fileNameArray
                                                           type:(nonnull NSString *)type
                                                           keys:(nonnull NSArray <NSString *> *)keys;

/**
 *  Class method for creating a request body that holds multipart request data
 *
 *  @param parameters           The post parameters for the request.
 *  @param filePathArray        The file paths of the files to upload.
 *  @param contentTypeArray     The content types of each of the files to upload.
 *  @param fileNameArray        The names of the files we want to upload.
 *  @param type                 The type of multipart request this is (eg "photo" for photo posts)
 *
 *  @return A new request body that is a multipart request body.
 */
+ (nonnull id <TMRequestBody>)defaultMultipartRequestBodyForParameters:(nullable NSDictionary *)parameters
                                                         filePathArray:(nonnull NSArray *)filePathArray
                                                      contentTypeArray:(nonnull NSArray *)contentTypeArray
                                                         fileNameArray:(nonnull NSArray *)fileNameArray
                                                                  type:(nonnull NSString *)type;


/**
 *  Allows key generation for passing into the multipart request body methods. 
 *
 *  This will look something like @[@"data", @"data"] if you passed in @"data" and 2 for the length.
 *
 *  @param length The number of keys you want to produce.
 *  @param key    The key you want to populate the resulting array with.
 *
 *  @return An array with the key string replicated by @c length times.
 */
+ (nonnull NSArray <NSString *> *)keyArrayOfLength:(NSInteger)length key:(nonnull NSString *)key;

@end
