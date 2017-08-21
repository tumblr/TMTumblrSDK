//
//  TMHTTPRequest.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/13/16.
//
//

#import "TMHTTPRequest.h"
#import "NSURLRequest+TMTumblrSDK.h"

@interface TMHTTPRequest ()

@property (nonatomic, readonly, nonnull, copy) NSString *URLString;

@end

@implementation TMHTTPRequest
@synthesize additionalHeaders = _additionalHeaders;
@synthesize method = _method;
@synthesize queryParameters = _queryParameters;
@synthesize requestBody = _requestBody;
@synthesize isSigned = _isSigned;
@synthesize isUpload = _isUpload;

- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
                                   method:(TMHTTPRequestMethod)method {
    NSParameterAssert(URLString);
    return [self initWithURLString:URLString
                            method:method
                 additionalHeaders:nil
                       requestBody:nil
                          isSigned:NO
                          isUpload:NO];
}

- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
                                   method:(TMHTTPRequestMethod)method
                        additionalHeaders:(nullable NSDictionary *)additionalHeaders
                              requestBody:(nullable id <TMRequestBody>)requestBody
                                 isSigned:(BOOL)isSigned
                                 isUpload:(BOOL)isUpload {

    NSParameterAssert(URLString);

    self = [super init];
    
    if (self) {
        _isUpload = isUpload;
        _URLString = [URLString copy];
        _method = method;
        _requestBody = requestBody;
        _additionalHeaders = [additionalHeaders copy];
        _isSigned = isSigned;
    }
    
    return self;
}

#pragma mark Private -

- (nonnull NSURL *)URL {
    NSURL *URL = [[NSURL alloc] initWithString:self.URLString];

    if (!URL) {
        @throw [[NSException alloc] initWithName:@"Illegal URL or Path exception" reason:@"The URL generated was nil." userInfo:nil];
    }

    return URL;
}

- (nonnull id <TMRequest>)requestByAddingQueryParameters:(nonnull NSDictionary *)queryParameters {

    /**
     *  Since we do not support query parameters from this class yet, we can simply return self.
     */
    return self;
}

- (nonnull instancetype)requestByAddingAdditionalHeaders:(nonnull NSDictionary *)additionalHeaders {
    NSParameterAssert(additionalHeaders);

    NSMutableDictionary *mutableHeaders = [(self.additionalHeaders ?: @{}) mutableCopy];
    [mutableHeaders addEntriesFromDictionary:additionalHeaders];
    return [[[self class] alloc] initWithURLString:self.URLString
                                            method:self.method
                                 additionalHeaders:[mutableHeaders copy]
                                       requestBody:self.requestBody
                                          isSigned:self.isSigned
                                          isUpload:self.isUpload];
}

@end
