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
            [client viewBlog:@"developers"];
            break;
        case TMAppClientActionViewPost:
            [client viewPost:@"43515916425" blogName:@"developers"];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
