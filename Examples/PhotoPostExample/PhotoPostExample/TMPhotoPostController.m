//
//  TMPhotoPostController.m
//  PhotoPostExample
//
//  Created by Bryan Irace on 5/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMPhotoPostController.h"

#import "TMAPIClient.h"
#import <Keys/PhotoPostExampleKeys.h>

@implementation TMPhotoPostController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Post photo" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(postPhoto) forControlEvents:UIControlEventTouchUpInside];

    CGRect screenRect  = [[UIScreen mainScreen] bounds];
    button.center = CGPointMake(screenRect.size.width / 2, screenRect.size.height / 2);

    [self.view addSubview:button];
    
    
    PhotoPostExampleKeys *keys = [[PhotoPostExampleKeys alloc] init];
    [TMAPIClient sharedInstance].OAuthConsumerKey = keys.oAuthConsumerKey;
    [TMAPIClient sharedInstance].OAuthConsumerSecret = keys.oAuthConsumerSecret;
}

- (void)postPhoto {
    void (^userInfoDone)(id, NSError *) = ^(id response, NSError *error) {
        [[TMAPIClient sharedInstance] post:response[@"user"][@"name"]
                                      type:@"photo"
                                parameters:@{@"data64" : [self base64ImageNamed:@"blue.png"], @"caption" : @"Caption"}
                                  callback:^(id response, NSError *error) {
                                      if (error)
                                          NSLog(@"Error posting to Tumblr");
                                      else
                                          NSLog(@"Posted to Tumblr");
        }];
    };
    
    void (^authticateDone)(NSError *) = ^(NSError * error) {
        if (error)
            NSLog(@"Error authenticate to Tumblr");
        else
            [[TMAPIClient sharedInstance] userInfo:userInfoDone];
    };

    [[TMAPIClient sharedInstance] authenticate:@"PhotoPostExample"
                            fromViewController:self
                                      callback:authticateDone];
}

#pragma mark - Private

- (NSString *)base64ImageNamed:(NSString *)name {
    return UIImagePNGRepresentation([UIImage imageNamed:name]).base64Encoding;
}

@end
