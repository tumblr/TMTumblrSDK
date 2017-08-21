//
//  TMAPIErrorFactoryTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 7/19/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMAPIErrorFactoryTests : XCTestCase

@end

@implementation TMAPIErrorFactoryTests

- (BOOL)singlePasses:(NSString *)title detail:(NSString *)detail logout:(BOOL)logout {
    TMAPIErrorFactory *factory = [[TMAPIErrorFactory alloc] initWithErrors:@[
                                                                             @{
                                                                                 @"code" : @1001,
                                                                                 @"title" : title,
                                                                                 @"logout": @(logout),
                                                                                 @"detail" : detail
                                                                                 }

                                                                             ] legacy:NO];

    NSArray <id <TMAPIError>> *errors = [factory APIErrors];
    
    id <TMAPIError> error = [errors firstObject];

    return [error logout] == logout && [[error detail] isEqualToString:detail] && [[error title] isEqualToString:title];
}

- (BOOL)singlePassesLegacy:(NSString *)title detail:(NSString *)detail {
    TMAPIErrorFactory *factory = [[TMAPIErrorFactory alloc] initWithErrors:@[
                                                                             @{
                                                                                 title : detail,
                                                                                 }

                                                                             ] legacy:YES];

    NSArray <id <TMAPIError>> *errors = [factory APIErrors];

    id <TMAPIError> error = [errors firstObject];

    return [error logout] == NO && [[error detail] isEqualToString:detail] && [[error title] isEqualToString:title];
}


- (void)testOneObjectCorrectlyTranslatesToModelObjectWithLogout {

    XCTAssert([self singlePasses:@"UNAUTHORIZED!" detail:@"You got chainsed." logout:YES]);
}

- (void)testOneObjectCorrectlyTranslatesToModelObjectWithNoLogout {

    XCTAssert([self singlePasses:@"noadsfhio!" detail:@"You got chainsed." logout:NO]);
}

- (void)testSingleLegacy {
    XCTAssert([self singlePassesLegacy:@"noadsfhio!" detail:@"You got chainsed."]);
}

- (void)testMultipleLegacyObjectsCorrectlyTranslatesToModelObjectWithNoLogout {

    TMAPIErrorFactory *factory = [[TMAPIErrorFactory alloc] initWithErrors:@[
                                                                             @{
                                                                                 @"title" : @"We messed up!",
                                                                                 @"detail" : @"idek!"
                                                                                 },
                                                                             @{
                                                                                 @"kenny" : @"chains"
                                                                                 }

                                                                             ] legacy:YES];

    NSArray <id <TMAPIError>> *errors = [factory APIErrors];

    id <TMAPIError> error = [errors firstObject];

    XCTAssert(![error logout]);
    XCTAssert([[error title] isEqualToString:@"title"]);
    XCTAssert([[error detail] isEqualToString:@"We messed up!"]);

    error = errors[1];

    XCTAssert(![error logout]);
    XCTAssert([[error detail] isEqualToString:@"idek!"]);
    XCTAssert([[error title] isEqualToString:@"detail"]);

    error = errors[2];

    XCTAssert(![error logout]);
    XCTAssert([[error detail] isEqualToString:@"chains"]);
    XCTAssert([[error title] isEqualToString:@"kenny"]);
}

- (void)testMultipleObjectsCorrectlyTranslatesToModelObjectWithNoLogout {

    TMAPIErrorFactory *factory = [[TMAPIErrorFactory alloc] initWithErrors:@[
                                                                             @{
                                                                                 @"code" : @1001,
                                                                                 @"title" : @"We messed up!",
                                                                                 @"logout": @NO,
                                                                                 @"detail" : @"idek!"
                                                                                 },
                                                                             @{
                                                                                 @"code" : @1001,
                                                                                 @"title" : @"Unauthorized",
                                                                                 @"logout": @YES,
                                                                                 @"detail" : @"Account is chainsed!"
                                                                                 }

                                                                             ] legacy:NO];

    NSArray <id <TMAPIError>> *errors = [factory APIErrors];

    id <TMAPIError> error = [errors firstObject];

    XCTAssert(![error logout]);
    XCTAssert([[error detail] isEqualToString:@"idek!"]);
    XCTAssert([[error title] isEqualToString:@"We messed up!"]);

    error = [errors lastObject];

    XCTAssert([error logout]);
    XCTAssert([[error detail] isEqualToString:@"Account is chainsed!"]);
    XCTAssert([[error title] isEqualToString:@"Unauthorized"]);
}

- (void)testWronglyFormattedLegacyErrorsDoNotCrashTheApp {
    TMAPIErrorFactory *factory = [[TMAPIErrorFactory alloc] initWithErrors:@[
                                                                             @"title",
                                                                             @"detail"
                                                                             ] legacy:YES];
    [factory APIErrors];
}

@end
