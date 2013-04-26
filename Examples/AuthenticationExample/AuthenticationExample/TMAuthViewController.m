//
//  TMAuthViewController.m
//  AuthenticationExample
//
//  Created by Bryan Irace on 4/26/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMAuthViewController.h"
#import "TMAPIClient.h"

@implementation TMAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Auth. with Tumblr" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(auth) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    [self.view addSubview:button];
}

- (void)auth {
    [[TMAPIClient sharedInstance] authenticate:@"tumblr_auth_example" callback:^(NSError *error) {
        if (error)
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        else
            NSLog(@"Authentication successful!");
    }];
}

@end
