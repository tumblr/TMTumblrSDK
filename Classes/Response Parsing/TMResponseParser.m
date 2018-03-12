//
//  TMResponseParser.m
//  Pods
//
//  Created by Kenny Ackerson on 4/26/16.
//
//

#import "TMResponseParser.h"
#import "TMParsedHTTPResponse.h"
#import "TMHTTPResponseErrorCodes.h"
#import "TMAPIError.h"
#import "TMAPIErrorFactory.h"

@interface TMResponseParser ()

@property (nonatomic, nullable, readonly) NSData *data;
@property (nonatomic, nullable, readonly) NSURLResponse *URLResponse;
@property (nonatomic, nullable, readonly) NSError *error;
@property (nonatomic, readonly) BOOL serializeJSON;

@end

@implementation TMResponseParser

- (nonnull instancetype)initWithData:(nullable NSData *)data
                         URLResponse:(nullable NSURLResponse *)URLResponse
                               error:(nullable NSError *)error
                       serializeJSON:(BOOL)serializeJSON {
    self = [super init];

    if (self) {
        _data = data;
        _URLResponse = URLResponse;
        _error = error;
        _serializeJSON = serializeJSON;
    }
    
    return self;
}

- (nonnull TMParsedHTTPResponse *)parse {

    /**
     *  Tumblr's API only communicates in HTTP.
     */
    if (![self.URLResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        return [[TMParsedHTTPResponse alloc] initWithJSONDictionary:nil
                                                         successful:NO
                                                responseDescription:self.URLResponse.description
                                                              error:self.error ?: [[NSError alloc]
                                                                                   initWithDomain:@"com.tumblr.TMTumblrSDK"
                                                                                   code:TMHTTPResponseErrorCodeWrongResponseType
                                                                                   userInfo:nil]
                                                          APIErrors:@[]
                                                         statusCode:0];
    }

    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.URLResponse;

    /**
     *  We only consider 20x requests to be successful. Integer division ensures that stuff like 201 here works correctly.
     */
    const BOOL successful = response.statusCode / 100 == 2;

    NSDictionary *JSON = [self JSON];
    NSDictionary *responseJSON = [self calculateResponseFromJSON:JSON];
    NSArray <id <TMAPIError>> *APIErrors = [self errors:JSON responseJSON:responseJSON];

    return [[TMParsedHTTPResponse alloc] initWithJSONDictionary:responseJSON
                                                     successful:successful
                                            responseDescription:response.description
                                                          error:self.error ?: (successful ? nil : [NSError errorWithDomain:@"Request failed" code:response.statusCode  userInfo:nil])
                                                      APIErrors:APIErrors
                                                     statusCode:response.statusCode];
}

#pragma mark - Private

- (nonnull NSArray <id <TMAPIError>> *)errors:(nonnull NSDictionary *)fullJSON responseJSON:(nonnull NSDictionary *)responseJSON {

    id topLevelErrors = fullJSON[@"errors"];

    if ([topLevelErrors isKindOfClass:[NSArray class]]) {
        return [[[TMAPIErrorFactory alloc] initWithErrors:topLevelErrors legacy:NO] APIErrors];
    }
    else {
        id legacyErrors = responseJSON[@"errors"];

        if ([legacyErrors isKindOfClass:[NSArray class]]) {
            return [[[TMAPIErrorFactory alloc] initWithErrors:legacyErrors legacy:YES] APIErrors];
        }
        /**
         *  We also support this format (the errors key being a dictionary/object).
         */
        else if ([legacyErrors isKindOfClass:[NSDictionary class]]) {
            return [[[TMAPIErrorFactory alloc] initWithErrors:@[legacyErrors] legacy:YES] APIErrors];
        }
    }

    return @[];
}

- (nonnull NSDictionary *)calculateResponseFromJSON:(nonnull NSDictionary *)JSON {

    const id response = JSON[@"response"];

    if ([response isKindOfClass:[NSDictionary class]]) {
        return response;
    }

    return @{};
}

- (nonnull NSDictionary *)JSON {
    NSData *data = self.data;

    /**
     *  We only want to attempt JSON serialization if we have valid data and the client wants us too.

     *  We also want to return a blank dictionary if we have no data. The orginal for this flatMapped over the Result<T, U> in our private library and returned nil - we need to keep this behavior so we know when this fails.
     */
    if (self.serializeJSON && data && data.length > 0) {

        id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:nil];

        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            return JSONObject;
        }
    }

    return @{};
}

@end
