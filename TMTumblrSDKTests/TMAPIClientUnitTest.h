//
//  TMAPIClientUnitTest.h
//  TumblrSDK
//
//  Created by John Crepezzi on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <OCMock/OCMockObject.h>
#import <OCMock/OCMArg.h>
#import <SenTestingKit/SenTestingKit.h>
#import "TMAPIClient.h"

@interface TMAPIClientUnitTest : SenTestCase

@property(nonatomic, retain) TMAPIClient *client;

- (void) setUp;

- (void) assertCallback:(void(^)(id, TMAPICallback))action;
- (void) assertSimilarRequest:(JXHTTPOperation*)op1 to:(JXHTTPOperation*)op2;
- (void) assertMultipartBody:(JXHTTPOperation*)op is:(NSString*)expected;
- (void) assertBody:(JXHTTPOperation*)op is:(NSDictionary*)expected;
- (void) assertQuery:(JXHTTPOperation*)op is:(NSString*)expected;
-(void) assertPath:(JXHTTPOperation*)op is:(NSString*)expected;
-(void) assertMethod:(JXHTTPOperation*)op is:(NSString*)expected;

@end
