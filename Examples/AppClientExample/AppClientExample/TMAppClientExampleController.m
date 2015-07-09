//
//  TMAppClientExampleControllerViewController.m
//  AppClientExample
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "TMAppClientExampleController.h"

#import "TMTumblrAppClient.h"

typedef enum {
    TMAppClientActionViewInAppStore,
    TMAppClientActionViewDashboard,
    TMAppClientActionViewExplore,
    TMAppClientActionViewActivity,
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
    
    self.toolbarItems = @[
        flexibleSpace,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self
                                                action:@selector(action:)],
        flexibleSpace
    ];
}

#pragma mark - Actions

- (void)action:(UIBarButtonItem *)item {
    // Tumblr can be used to open images and video files for creating photo and video posts respectively.
    
    NSURL *URL = [[NSBundle bundleForClass:[TMAppClientExampleController class]] URLForResource:@"tumblr" withExtension:@"png"];
    
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    controller.annotation = @{ @"TumblrCaption" : @"Caption for photo or video post.", @"TumblrTags" : @[ @"foo", @"bar" ] };
    controller.UTI = @"com.tumblr.photo";
    
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
        case TMAppClientActionViewExplore:
            cell.textLabel.text = @"View explore";
            break;
        case TMAppClientActionViewActivity:
            cell.textLabel.text = @"View activity";
            break;
        case TMAppClientActionViewTag:
            cell.textLabel.text = @"View GIF tag";
            break;
        case TMAppClientActionViewBlog:
            cell.textLabel.text = @"View Tumblr developers blog";
            break;
        case TMAppClientActionViewPost:
            cell.textLabel.text = @"View Tumblr developers blog post";
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
    NSURL *successURL = [NSURL URLWithString:@"tumblrappclientexample://success"];
    NSURL *cancelURL = [NSURL URLWithString:@"tumblrappclientexample://cancelled"];
    
    switch (indexPath.row) {
        case TMAppClientActionViewInAppStore:
            [TMTumblrAppClient viewInAppStore];
            break;
        case TMAppClientActionViewDashboard:
            [TMTumblrAppClient viewDashboard];
            break;
        case TMAppClientActionViewExplore:
            [TMTumblrAppClient viewExplore];
            break;
        case TMAppClientActionViewActivity:
            [TMTumblrAppClient viewActivityForPrimaryBlog];
            break;
        case TMAppClientActionViewTag:
            [TMTumblrAppClient viewTag:@"gif"];
            break;
        case TMAppClientActionViewBlog:
            [TMTumblrAppClient viewBlog:@"developers"];
            break;
        case TMAppClientActionViewPost:
            [TMTumblrAppClient viewPost:@"43515916425" blogName:@"developers"];
            break;
        case TMAppClientActionCreateTextPost:
            [TMTumblrAppClient createTextPost:@"Title" body:@"Body" tags:@[@"gif", @"lol"] success:successURL
                                       cancel:cancelURL];
            break;
        case TMAppClientActionCreateLinkPost:
            [TMTumblrAppClient createLinkPost:@"Tumblr" URLString:@"http://tumblr.com"
                                  description:@"Follow the world's creators" tags:@[@"gif", @"lol"] success:successURL
                                       cancel:cancelURL];
            break;
        case TMAppClientActionCreateQuotePost:
            [TMTumblrAppClient createQuotePost:@"Fellas, don't drink that coffee! You'd never guess. There was a fish..."
             "in the percolator! Sorry..." source:@"Pete" tags:@[@"gif", @"lol"] success:successURL cancel:cancelURL];
            break;
        case TMAppClientActionCreateChatPost:
            [TMTumblrAppClient createChatPost:@"Chat" body:@"Peter: I'm like a sweet peach on a hot summer day.\nMegan:"
             "You're like a sour pickle on a windy day." tags:@[@"gif", @"lol"] success:successURL cancel:cancelURL];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
