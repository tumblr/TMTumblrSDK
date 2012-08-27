//
//  TMAPIClient.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXHTTP.h"

typedef void (^TMAPISuccessCallback)(id);
typedef void (^TMAPIErrorCallback)(NSError *, NSArray *);

@interface TMAPIClient : NSObject <JXHTTPOperationDelegate>

+ (id)sharedInstance;

- (void)blogInfo:(NSString *)blogName success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

@end
