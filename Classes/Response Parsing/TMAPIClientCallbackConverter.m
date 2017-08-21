//
//  TMAPIClientCallbackConverter.m
//  Pods
//
//  Created by Kenny Ackerson on 5/3/16.
//
//

#import "TMAPIClientCallbackConverter.h"

#import "TMResponseParser.h"
#import "TMParsedHTTPResponse.h"

@interface TMAPIClientCallbackConverter ()

@property (nonatomic, copy, readonly, nonnull) TMAPIClientCallback callback;

@end

@implementation TMAPIClientCallbackConverter

- (nonnull instancetype)initWithCallback:(nonnull TMAPIClientCallback)callback {
    NSParameterAssert(callback);
    self = [super init];

    if (self) {
        _callback = [callback copy];
    }

    return self;
}

- (nonnull TMURLSessionRequestCompletionHandler)completionHandler {

    /**
     *  No need to reference self in this block thats returned - would simply make this object live longer
     */
    TMAPIClientCallback copyOfCallback = [self.callback copy];

    return ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        TMResponseParser * const parser = [[TMResponseParser alloc] initWithData:data URLResponse:response error:error serializeJSON:YES];

        TMParsedHTTPResponse * const parsedResponse = [parser parse];

        dispatch_async(dispatch_get_main_queue(), ^{
            copyOfCallback(parsedResponse.JSONDictionary, parsedResponse.error);
        });
    };
}

@end
