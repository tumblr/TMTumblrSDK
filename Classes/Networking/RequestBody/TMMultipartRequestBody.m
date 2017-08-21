//
//  TMMultipartRequestBody.m
//  Pods
//
//  Created by Kenny Ackerson on 5/10/16.
//
//

#import "TMMultipartRequestBody.h"
#import "TMMultipartFormData.h"
#import "TMMultipartConstants.h"
#import "TMMultipartPart.h"

@interface TMMultipartRequestBody ()

@property (nonatomic, readonly, nonnull) NSArray<NSString *> *filePaths;
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *contentTypes;
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *fileNames;

@property (nonatomic, readonly, nonnull) NSDictionary *parameters;

@property (nonatomic, readonly, nonnull) NSArray <NSString *> *keys;
@property (nonatomic) BOOL encodeJSONBody;

@end

@implementation TMMultipartRequestBody

- (nonnull instancetype)initWithFilePaths:(nonnull NSArray<NSString *> *)filePaths
                             contentTypes:(nonnull NSArray<NSString *> *)contentTypes
                                fileNames:(nonnull NSArray<NSString *> *)fileNames
                               parameters:(nonnull NSDictionary *)parameters
                                     keys:(nonnull NSArray <NSString *> *)keys
                           encodeJSONBody:(BOOL)encodeJSONBody {
    NSParameterAssert(filePaths);
    NSParameterAssert(contentTypes);
    NSParameterAssert(fileNames);
    NSParameterAssert(parameters);
    NSParameterAssert(keys);

    NSParameterAssert(fileNames.count == filePaths.count);
    NSParameterAssert(filePaths.count == contentTypes.count);
    NSParameterAssert(filePaths.count == keys.count);

    self = [super init];

    if (self) {
        _filePaths = filePaths;
        _contentTypes = contentTypes;
        _fileNames = fileNames;
        _parameters = parameters;
        _keys = keys;
        _encodeJSONBody = encodeJSONBody;
    }

    return self;
}

- (nullable NSString *)contentType {
    return [[NSString alloc] initWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", TMMultipartBoundary];
}

- (nullable NSData *)bodyData {

    NSMutableArray *parts = [[NSMutableArray alloc] init];

    const BOOL multiple = [self hasMultipleDistinctFiles];

    [self.filePaths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger index, BOOL *stop) {

        if ([filePath isKindOfClass:[NSNull class]]) {
            return;
        }

        NSString *key = self.keys[index];

        NSAssert(key, @"We must have a key here or else the multipart request body is invalid.");

        NSData *data = [NSData dataWithContentsOfFile:filePath];

        NSAssert(data, @"We _must_ be able to access the file at this file path %@", filePath);

        if (!data) {
            NSLog(@"File at path: %@ couldnt be loaded - critical error", filePath);
            return;
        }

        TMMultipartPart *part = [[TMMultipartPart alloc] initWithData:data
                                                                 name:multiple ? [NSString stringWithFormat:@"%@[%lu]", key, (unsigned long)index] : key
                                                             fileName:self.fileNames[index]
                                                          contentType:self.contentTypes[index]];
        [parts addObject:part];
    }];

    NSDictionary *parameters = self.parameters;

    if (self.encodeJSONBody) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];

        if (JSONData) {
            [parts addObject:[[TMMultipartPart alloc] initWithData:JSONData
                                                              name:@"json"
                                                          fileName:nil
                                                       contentType:@"application/json; charset=utf-8"]];
        }
    }
    else {
        for (NSString *key in [parameters allKeys]) {
            [parts addObject:[[TMMultipartPart alloc] initWithData:[parameters[key] dataUsingEncoding:NSUTF8StringEncoding]
                                                              name:key
                                                          fileName:nil
                                                       contentType:@"text/plain; charset=utf-8"]];
        }
    }

    TMMultipartFormData *formData = [[TMMultipartFormData alloc] initWithParts:parts boundary:TMMultipartBoundary];

    return [formData dataRepresentation];
}

- (BOOL)encodeParameters {
    return NO;
}

#pragma mark - Private

- (BOOL)hasMultipleDistinctFiles {

    NSMutableSet *temporaryContainer = [[NSMutableSet alloc] init];

    for (NSString *key in self.keys) {
        if ([temporaryContainer containsObject:key]) {
            return YES;
        }

        [temporaryContainer addObject:key];
    }

    return NO;
}

@end
