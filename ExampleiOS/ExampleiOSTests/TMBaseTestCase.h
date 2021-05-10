//
//  TMBaseTestCase.h
//  ExampleiOS
//
//  Created by Pinar Olguc on 10.05.2021.
//  Copyright © 2021 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TMBaseTestCase : XCTestCase

- (NSURL *)tempFileURL;

- (NSURL *)tempTestDirectory;

@end
