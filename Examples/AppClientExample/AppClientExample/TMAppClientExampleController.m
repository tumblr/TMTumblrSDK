//
//  TMAppClientExampleControllerViewController.m
//  AppClientExample
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMAppClientExampleController.h"

#import "TMTumblrAppClient.h"
#import "TMTumblrActivity.h"

typedef enum {
    TMAppClientActionViewInAppStore,
    TMAppClientActionViewDashboard,
    TMAppClientActionViewTag,
    TMAppClientActionViewBlog,
    TMAppClientActionViewPost,
    TMAppClientActionCreateTextPost,
    TMAppClientActionCreateLinkPost,
    TMAppClientActionCreateQuotePost,
    TMAppClientActionCreateChatPost,
    TMAppClientActionCount
} TMAppClientActions;

@interface TMAppClientExampleController()

@property (nonatomic, strong) UIDocumentInteractionController *interactionController;

@end

@implementation TMAppClientExampleController

static NSString *cellIdentifier = @"cellIdentifier";

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped])
        self.title = @"Tumblr app client";
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];
    
    self.toolbarItems = @[flexibleSpace,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self
                                                                        action:@selector(compose:)],
                          flexibleSpace,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self
                                                                        action:@selector(action:)],
                          flexibleSpace];
}

#pragma mark - Actions

- (void)compose:(UIBarButtonItem *)item {
    /*
     `TMTumblrActivity` is a blank slate right now. You can subclass it and implement it however you see fit, presumably
     using either `TMTumblrAppClient` for inter-app communcation of `TMAPIClient` from the Tumblr iOS SDK
     (https://github.com/tumblr/tumblr-ios-sdk) for hitting our API directly.
     */
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[]
                                                                             applicationActivities:@[[[TMTumblrActivity alloc] init]]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)action:(UIBarButtonItem *)item {
    // Tumblr can be used to open images and video files for creating photo and video posts respectively.
    
    NSURL *URL = [[NSBundle bundleForClass:[TMAppClientExampleController class]] URLForResource:@"tumblr" withExtension:@"png"];
    
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    self.interactionController = controller;
    [controller presentOpenInMenuFromBarButtonItem:item animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TMAppClientActionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case TMAppClientActionViewInAppStore:
            cell.textLabel.text = @"View in App Store";
            break;
        case TMAppClientActionViewDashboard:
            cell.textLabel.text = @"View dashboard";
            break;
        case TMAppClientActionViewTag:
            cell.textLabel.text = @"View GIF tag";
            break;
        case TMAppClientActionViewBlog:
            cell.textLabel.text = @"View Bryan's blog";
            break;
        case TMAppClientActionViewPost:
            cell.textLabel.text = @"View Bryan's dog pictures";
            break;
        case TMAppClientActionCreateTextPost:
            cell.textLabel.text = @"Create text post";
            break;
        case TMAppClientActionCreateLinkPost:
            cell.textLabel.text = @"Create link post";
            break;
        case TMAppClientActionCreateQuotePost:
            cell.textLabel.text = @"Create quote post";
            break;
        case TMAppClientActionCreateChatPost:
            cell.textLabel.text = @"Create chat post";
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TMTumblrAppClient *client = [TMTumblrAppClient client];
    
    switch (indexPath.row) {
        case TMAppClientActionViewInAppStore:
            [client viewInAppStore];
            break;
        case TMAppClientActionViewDashboard:
            [client viewDashboard];
            break;
        case TMAppClientActionViewTag:
            [client viewTag:@"gif"];
            break;
        case TMAppClientActionViewBlog:
            [client viewBlog:@"bryan"];
            break;
        case TMAppClientActionViewPost:
            [client viewPost:@"43724939726" blogName:@"bryan"];
            break;
        case TMAppClientActionCreateTextPost:
            [client createTextPost:@"Title" body:@"Body"];
            break;
        case TMAppClientActionCreateLinkPost:
            [client createLinkPost:@"Tumblr" URL:@"http://tumblr.com" description:@"Follow the world's creators"];
            break;
        case TMAppClientActionCreateQuotePost:
            [client createQuotePost:@"Fellas, don't drink that coffee! You'd never guess. There was a fish... in the percolator! Sorry..." source:@"Pete"];
            break;
        case TMAppClientActionCreateChatPost:
            [client createChatPost:@"Chat" body:@"Peter: I'm like a sweet peach on a hot summer day.\nMegan: You're like a sour pickle on a windy day."];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
