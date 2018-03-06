//
//  TMResponseParserErrorTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 7/19/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TMTumblrSDK;

@interface TMResponseParserErrorTests : XCTestCase

@end

@implementation TMResponseParserErrorTests

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForTopLevel {

    NSArray *errors = @[
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
                        ];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"right" : @"type", @"of": @"response!"}, @"errors" : errors }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:NO];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);

    for (NSInteger i = 0; i < errorFactory.APIErrors.count; i++) {
        id <TMAPIError> error = parseErrors[i];
        id <TMAPIError> otherError = errorFactoryErrors[i];

        XCTAssert([[otherError title] isEqualToString:[error title]]);
        XCTAssert([[otherError detail] isEqualToString:[error detail]]);
        XCTAssert([otherError logout] == [error logout]);
        XCTAssert([otherError code] == [error code]);
    }

}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForTopLevelInvalidFormat {

    NSArray *errors = @[
                        @{
                            @"not" : @"right",
                            @"title" : @"okay this is good but nothing else!?"
                            }
                        ];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"right" : @"type", @"of": @"response!"}, @"errors" : errors }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:NO];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 0);
    
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForTopLevelWrongTypeButOneRightTypes {

    NSArray *errors = @[
                        @{
                            @"detail" : @3234,
                            @"title" : @{ },
                            @"logout" : @"what"
                            },
                        @{
                            @"code" : @1001,
                            @"title" : @"Unauthorized",
                            @"logout": @YES,
                            @"detail" : @"Account is chainsed!"
                            }
                        ];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"right" : @"type", @"of": @"response!"}, @"errors" : errors }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:NO];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 1);
    for (NSInteger i = 0; i < errorFactory.APIErrors.count; i++) {
        id <TMAPIError> error = parseErrors[i];
        id <TMAPIError> otherError = errorFactoryErrors[i];

        XCTAssert([[otherError title] isEqualToString:[error title]]);
        XCTAssert([[otherError detail] isEqualToString:[error detail]]);
        XCTAssert([otherError logout] == [error logout]);
    }
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForTopLevelWrongType {

    NSArray *errors = @[
                        @{
                            @"detail" : @3234,
                            @"title" : @{ },
                            @"logout" : @"what"
                            }
                        ];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"right" : @"type", @"of": @"response!"}, @"errors" : errors }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:NO];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 0);
    
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForLegacy {

    NSArray *errors = @[
                        @{
                            @"It is broken" : @"idk!",
                            @"It is still broken" : @"help"
                            }
                        ];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"errors" : errors, @"right" : @"type", @"of": @"response!"} }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:YES];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);

    for (NSInteger i = 0; i < errorFactory.APIErrors.count; i++) {
        id <TMAPIError> error = parseErrors[i];
        id <TMAPIError> otherError = errorFactoryErrors[i];

        XCTAssert([[otherError title] isEqualToString:[error title]]);
        XCTAssert([[otherError detail] isEqualToString:[error detail]]);
        XCTAssert([otherError logout] == [error logout]);
    }
    
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForLegacyOnlyDictionary {

    NSDictionary *errors = @{
                            @"It is broken" : @"idk!",
                            @"It is still broken" : @"help"
                            };

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"errors" : errors, @"right" : @"type", @"of": @"response!"} }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:@[errors] legacy:YES];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);

    for (NSInteger i = 0; i < errorFactory.APIErrors.count; i++) {
        id <TMAPIError> error = parseErrors[i];
        id <TMAPIError> otherError = errorFactoryErrors[i];

        XCTAssert([[otherError title] isEqualToString:[error title]]);
        XCTAssert([[otherError detail] isEqualToString:[error detail]]);
        XCTAssert([otherError logout] == [error logout]);
    }
    
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForLegacyOnlyemptyDictionary {

    NSDictionary *errors = @{ };

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"errors" : errors, @"right" : @"type", @"of": @"response!"} }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:@[errors] legacy:YES];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 0);
    
}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForLegacyEmptyArray {

    NSArray *errors = @[];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"errors" : errors, @"right" : @"type", @"of": @"response!"} }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:YES];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 0);

}

- (void)testErrorsAreSameAfterParsingAreSameForWhatComesOutOfErrorFactoryForTopLevelEmptyArray {

    NSArray *errors = @[];

    TMResponseParser *responseParser = [[TMResponseParser alloc] initWithData:[self dataForJSONObject:@{@"response" : @{@"right" : @"type", @"of": @"response!"}, @"errors" : errors }]
                                                                  URLResponse:[[NSHTTPURLResponse alloc] init]
                                                                        error:nil
                                                                serializeJSON:YES];

    TMAPIErrorFactory *errorFactory = [[TMAPIErrorFactory alloc] initWithErrors:errors legacy:NO];

    NSArray <id <TMAPIError>> *parseErrors = responseParser.parse.APIErrors;
    NSArray <id <TMAPIError>> *errorFactoryErrors = [errorFactory APIErrors];

    XCTAssert(parseErrors.count == errorFactoryErrors.count);
    XCTAssert(parseErrors.count == 0);
    
}



- (NSData *)dataForJSONObject:(id)JSONObject {
    return [NSJSONSerialization dataWithJSONObject:JSONObject options:0 error:nil];
}

@end
