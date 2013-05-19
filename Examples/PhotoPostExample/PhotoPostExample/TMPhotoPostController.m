//
//  TMPhotoPostController.m
//  PhotoPostExample
//
//  Created by Bryan Irace on 5/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMPhotoPostController.h"

#import "TMAPIClient.h"

@implementation TMPhotoPostController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Post photo" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(postPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // TODO: Fill in your keys and secrets
    
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"";
    [TMAPIClient sharedInstance].OAuthToken = @"";
    [TMAPIClient sharedInstance].OAuthTokenSecret = @"";
}

- (void)postPhoto {
    // TODO: Fill in your blog name
    
    [[TMAPIClient sharedInstance] photo:@""
                          filePathArray:@[[[NSBundle mainBundle] pathForResource:@"blue" ofType:@"png"]]
                       contentTypeArray:@[@"image/png"]
                          fileNameArray:@[@"blue.png"]
                             parameters:@{@"caption" : @"Caption"}
                               callback:^(id response, NSError *error) {
                                   if (error)
                                       NSLog(@"Error posting to Tumblr");
                                   else
                                       NSLog(@"Posted to Tumblr");
                               }];
}

@end
