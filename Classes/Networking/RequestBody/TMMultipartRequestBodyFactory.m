//
//  TMMultipartRequestBodyFactory.m
//  Pods
//
//  Created by Kenny Ackerson on 5/16/16.
//
//

#import "TMMultipartRequestBodyFactory.h"
#import "TMMultipartRequestBody.h"

@interface TMMultipartRequestBodyFactory ()

@end

@implementation TMMultipartRequestBodyFactory

+ (nonnull id <TMRequestBody>)multipartRequestBodyForParameters:(nullable NSDictionary *)parameters
                                                  filePathArray:(nonnull NSArray *)filePathArray
                                               contentTypeArray:(nonnull NSArray *)contentTypeArray
                                                  fileNameArray:(nonnull NSArray *)fileNameArray
                                                           type:(nonnull NSString *)type
                                                           keys:(nonnull NSArray <NSString *> *)keys {

    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (type) {
        mutableParameters[@"type"] = type;
    }

    return [[TMMultipartRequestBody alloc] initWithFilePaths:filePathArray
                                                contentTypes:contentTypeArray
                                                   fileNames:fileNameArray
                                                  parameters:[mutableParameters copy]
                                                        keys:keys
                                              encodeJSONBody:NO];

}

+ (nonnull id <TMRequestBody>)defaultMultipartRequestBodyForParameters:(nullable NSDictionary *)parameters
                                                         filePathArray:(nonnull NSArray *)filePathArray
                                                      contentTypeArray:(nonnull NSArray *)contentTypeArray
                                                         fileNameArray:(nonnull NSArray *)fileNameArray
                                                                  type:(nonnull NSString *)type {

    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

    if (type) {
        mutableParameters[@"type"] = type;
    }

    return [[TMMultipartRequestBody alloc] initWithFilePaths:filePathArray
                                                contentTypes:contentTypeArray
                                                   fileNames:fileNameArray
                                                  parameters:mutableParameters
                                                        keys:[self keyArrayOfLength:filePathArray.count key:@"data"]
                                              encodeJSONBody:NO];
    
}

+ (nonnull NSArray <NSString *> *)keyArrayOfLength:(NSInteger)length key:(nonnull NSString *)key {
    NSParameterAssert(key);
    NSParameterAssert(length > 0);

    NSMutableArray *keys = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < length; i++) {
        [keys addObject:key];
    }

    return [keys copy];
}

@end
