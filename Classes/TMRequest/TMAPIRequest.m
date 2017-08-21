//
//  TMAPIRequest.m
//  TMTumblrSDK
//
//  Created by Coulton Vento on 7/9/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

#import "TMAPIRequest.h"

@interface TMAPIRequest ()

/**
 *  The base URL for the request.
 */
@property (nonatomic, nonnull, readonly) NSURL *baseURL;

/**
 *  The path for the request.
 */
@property (nonatomic, nonnull, readonly) NSString *path;

@end

@implementation TMAPIRequest
@synthesize additionalHeaders = _additionalHeaders;
@synthesize method = _method;
@synthesize queryParameters = _queryParameters;
@synthesize requestBody = _requestBody;
@synthesize isUpload = _isUpload;

- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters
                            requestBody:(nullable id <TMRequestBody>)requestBody
                       additionalHeaders:(nullable NSDictionary *)additionalHeaders
                               isUpload:(BOOL)isUpload {

    self = [self initWithBaseURL:baseURL
                          method:method
                            path:path
                 queryParameters:queryParameters
                     requestBody:requestBody
                additionalHeaders:additionalHeaders];

    if (self) {
        _isUpload = isUpload;
    }

    return self;

}

- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters
                            requestBody:(nullable id <TMRequestBody>)requestBody
                       additionalHeaders:(nullable NSDictionary *)additionalHeaders {
    NSParameterAssert(baseURL);
    NSParameterAssert(path);

    self = [self initWithBaseURL:baseURL method:method path:path queryParameters:queryParameters];

    if (self) {
        _requestBody = requestBody;
        _additionalHeaders = [additionalHeaders copy];
    }

    return self;
}

- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters {
    NSParameterAssert(baseURL);
    NSParameterAssert(path);

    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _method = method;
        _path = [path copy];
        _queryParameters = [queryParameters copy];
    }

    NSParameterAssert([self URL]);
    return self;
}


- (nonnull instancetype)requestByAddingAdditionalHeaders:(nonnull NSDictionary *)additionalHeaders {
    NSParameterAssert(additionalHeaders);

    NSMutableDictionary *mutableHeaders = [(self.additionalHeaders ?: @{}) mutableCopy];
    [mutableHeaders addEntriesFromDictionary:additionalHeaders];
    return [[[self class] alloc] initWithBaseURL:self.baseURL
                                          method:self.method
                                            path:self.path
                                 queryParameters:self.queryParameters
                                     requestBody:self.requestBody
                               additionalHeaders:[mutableHeaders copy]];
}

- (nonnull instancetype)requestByAddingQueryParameters:(nonnull NSDictionary *)queryParameters {
    NSParameterAssert(queryParameters);

    NSMutableDictionary *mutableParameters = [(self.queryParameters ?: @{}) mutableCopy];
    [mutableParameters addEntriesFromDictionary:queryParameters];
    return [[[self class] alloc] initWithBaseURL:self.baseURL
                                          method:self.method
                                            path:self.path
                                 queryParameters:[mutableParameters copy]
                                     requestBody:self.requestBody
                                additionalHeaders:self.additionalHeaders];
}

- (nonnull NSURL *)URL {
    NSURL *URL = [self.baseURL URLByAppendingPathComponent:self.path];

    if (!URL) {
        @throw [[NSException alloc] initWithName:@"Illegal URL or Path exception" reason:@"The URL generated was nil." userInfo:nil];
    }

    return URL;
}

- (BOOL)isSigned {
    return YES;
}

@end
