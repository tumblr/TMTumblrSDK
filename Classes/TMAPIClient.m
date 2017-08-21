//
//  TMAPIClient.m
//  Pods
//
//  Created by Kenny Ackerson on 11/18/15.
//
//

#import "TMAPIClient.h"
#import "TMTumblrSDKErrorDomain.h"
#import "TMResponseParser.h"
#import "TMParsedHTTPResponse.h"
#import "TMAPIClientCallbackConverter.h"

@implementation TMAPIClient

- (nonnull instancetype)initWithSession:(nonnull id <TMSession>)session requestFactory:(nonnull TMRequestFactory *)requestFactory {
    NSParameterAssert(session);
    NSParameterAssert(requestFactory);
    self = [super init];
    
    if (self) {
        _session = session;
        _requestFactory = requestFactory;
    }
    
    return self;
}

// Shorthand over using @c TMAPIClientCallbackConverter directly everywhere
- (nonnull TMURLSessionRequestCompletionHandler)completionHandlerWithAPIClientCallback:(nonnull TMAPIClientCallback)callback {
    NSParameterAssert(callback);

    return [[[TMAPIClientCallbackConverter alloc] initWithCallback:callback] completionHandler];
}

- (nonnull NSURLSessionTask *)dashboardRequest:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory dashboardRequest:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:request completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)userInfoDataTaskWithCallback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory userInfoRequest] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)notesDataTaskWithPostID:(nonnull NSString *)postId blogUUID:(nonnull NSString *)blogUUID beforeDate:(nullable NSDate *)beforeDate :(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory notesRequestWithPostID:postId blogUUID:blogUUID beforeDate:beforeDate] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)likesDataTaskWithParameters:(nonnull NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory likesRequestWithParameters:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)likesDataTaskForBlogWithUUID:(nonnull NSString *)blogUUID parameters:(nonnull NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory likesRequestForBlogWithUUID:blogUUID queryParameters:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)blogInfoDataTaskForBlogName:(nonnull NSString *)blogName callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory blogInfoRequestForBlogName:blogName] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)followingDataTaskWithParameters:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory followingRequestWithParameters:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)avatarWithBlogName:(nonnull NSString *)blogName size:(NSUInteger)size callback:(nonnull TMURLSessionRequestCompletionHandler)callback {
    return [self.session taskWithRequest:[self.requestFactory avatarWithBlogName:blogName size:size] completionHandler:callback];
}

- (nonnull NSURLSessionTask *)followersRequestForBlogName:(nonnull NSString *)blogName
                                               parameters:(nonnull NSDictionary *)parameters
                                                 callback:(nonnull TMAPIClientCallback)callback {
    NSParameterAssert(blogName);
    NSParameterAssert(parameters);
    NSParameterAssert(callback);
    
    return [self.session taskWithRequest:[self.requestFactory
                                                     followersRequestForBlog:blogName
                                                     queryParameters:parameters]
                                  completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)postsTask:(nonnull NSString *)blogName
                                   type:(nullable NSString *)type
                        queryParameters:(nonnull NSDictionary *)parameters
                               callback:(nonnull TMAPIClientCallback)callback {

    return [self.session taskWithRequest:[self.requestFactory postsRequestWithBlogName:blogName type:type queryParameters:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)postDataTaskWithBlogName:(nonnull NSString *)blogName type:(nonnull NSString *)type parameters:(nonnull NSDictionary *)parameters callback:(nonnull TMURLSessionRequestCompletionHandler)callback {
    NSParameterAssert(blogName);
    NSParameterAssert(type);
    NSParameterAssert(parameters);
    NSParameterAssert(callback);
    
    return [self.session taskWithRequest:[self.requestFactory postsRequestWithBlogName:blogName type:type queryParameters:parameters] completionHandler:callback];
}

- (nonnull NSURLSessionTask *)editPost:(nonnull NSString *)blogName parameters:(nullable NSDictionary *)parameters callback:(nonnull TMAPIClientCallback)callback {
    return [self.session taskWithRequest:[self.requestFactory editPostRequest:blogName parameters:parameters] completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)draftsRequestForBlogWithName:(nonnull NSString *)blogName
                                                parameters:(nonnull NSDictionary *)parameters
                                                  callback:(nonnull TMAPIClientCallback)callback {
    NSParameterAssert(blogName);
    NSParameterAssert(parameters);
    NSParameterAssert(callback);
    
    return [self.session taskWithRequest:[self.requestFactory draftsRequestForBlog:blogName queryParameters:parameters]
                                  completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}

- (nonnull NSURLSessionTask *)submissionsRequestforBlogName:(nonnull NSString *)blogName
                                                 parameters:(nonnull NSDictionary *)parameters
                                                   callback:(nonnull TMAPIClientCallback)callback {
    NSParameterAssert(blogName);
    NSParameterAssert(parameters);
    NSParameterAssert(callback);
    
    return [self.session taskWithRequest:[self.requestFactory sumbissionsRequestForBlog:blogName queryParameters:parameters]
                                 completionHandler:[self completionHandlerWithAPIClientCallback:callback]];
}


@end
