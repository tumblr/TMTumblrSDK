//
//  TMWebViewController.m
//  TumblrAuthentication
//
//  Created by Sergey Shpuntov on 3/11/16.
//  Copyright (c) 2016 Tumblr. All rights reserved.
//

#import "TMWebViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED

@interface TMWebViewController ()

@property (nonatomic) UIWebView *webView;
@property (nonatomic) NSURL *initialURL;

@end

@implementation TMWebViewController

- (instancetype)initWithURL:(NSURL *)URL {
    NSParameterAssert(URL);

    if (self = [super initWithNibName:nil bundle:nil]) {
        _initialURL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [self createWebView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.initialURL]];

    self.title = @"Tumblr";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.webView.frame = self.view.bounds;
}

- (UIWebView *)createWebView {
    UIView *superview = self.view;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:superview.bounds];
    [superview addSubview:webView];
    return webView;
}

- (void)dismissAction {
    if ([self.delegate respondsToSelector:@selector(webViewControllerDidFinish:)]) {
        [self.delegate webViewControllerDidFinish:self];
    }
}

@end

#endif
