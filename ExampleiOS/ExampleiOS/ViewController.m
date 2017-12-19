//
//  ViewController.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 1/6/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import "ViewController.h"
#import "TMBasicBaseURLDeterminer.h"
#import <UIKit/UIKit.h>
#import <TMTumblrSDK/TMHTTPRequest.h>
#import <TMTumblrSDK/TMURLSession.h>
#import <TMTumblrSDK/TMOAuth.h>

@interface ViewController () <TMNetworkActivityIndicatorManager, TMSessionTaskUpdateDelegate>

@property (nonatomic) TMURLSession *session;
@property (nonatomic) TMOAuthAuthenticator *authenticator;

@property (nonatomic) UIButton *authButton;
@property (nonatomic) UITextView *authResultsTextView;
@property (nonatomic) UIButton *unauthedRequestButton;

@end

@implementation ViewController

- (instancetype)initWithSession:(TMURLSession *)session authenticator:(TMOAuthAuthenticator *)authenticator {
    self = [super init];
    if (self) {
        _session = session;
        _authenticator = authenticator;

        [[session taskWithRequest:[[TMHTTPRequest alloc] initWithURLString:@"http://www.guoguiyan.com/data/out/113/68555786-large-wallpapers.jpg" method:TMHTTPRequestMethodGET] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        }] resume];
    }
    return self;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = networkActivityIndicatorVisible;
}

- (void)URLSession:(NSURLSessionTask *)task updatedStatusTo:(TMURLSessionTaskState)state {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpSubviews];
}

- (void)authenticate {
    [self.authenticator authenticate:@"ello" callback:^(TMAPIUserCredentials *creds, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.authResultsTextView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
            }
            else {
                self.session = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@""] userCredentials:[[TMAPIUserCredentials alloc] initWithToken:creds.token tokenSecret:creds.tokenSecret]];
                self.authResultsTextView.text = [NSString stringWithFormat:@"Success!\nToken: %@\nSecret: %@", creds.token, creds.tokenSecret];
                [self request];
            }
        });
    }];
}

- (void)request {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    TMAPIClient *client = [[TMAPIClient alloc] initWithSession:self.session requestFactory:requestFactory];

    NSURLSessionTask *firstTask = [self.session taskWithRequest:[[TMHTTPRequest alloc] initWithURLString:@"https://yahoo.com" method:TMHTTPRequestMethodGET] incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) {
          NSLog(@"incrementally - %@", data);

    }
                                                progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) {

                                                } completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    // NSLog(@"Hello! %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                }];

    [firstTask resume];

    [self blogInfo:client requestFactory:requestFactory];

    NSURLSessionTask *dashboard = [client dashboardRequest:nil callback:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        NSLog(@"dashboard - %@", response);
    }];

    [dashboard resume];
}

- (void)blogInfo:(TMAPIClient *)client requestFactory:(TMRequestFactory *)requestFactory {
    NSURLSessionTask *task = [client blogInfoDataTaskForBlogName:@"ios" callback:^(id  _Nullable JSONResponse, NSError * _Nullable error) {
    }];

    [task resume];
}

- (void)blogInfo {
    TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];

    TMAPIClient *client = [[TMAPIClient alloc] initWithSession:self.session requestFactory:requestFactory];

    [self blogInfo:client requestFactory:requestFactory];
}

- (void)setUpSubviews {
    [self setUpAuthenticateButton];
    [self setUpResultsTextView];
    [self setUpUnauthedRequestButton];
}

- (void)setUpAuthenticateButton {
    self.authButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.authButton.frame = CGRectMake(25, 50, 175, 30);
    self.authButton.backgroundColor = [UIColor blueColor];
    self.authButton.layer.cornerRadius = 10;
    self.authButton.titleLabel.textColor = [UIColor whiteColor];
    [self.authButton setTitle:@"Authenticate" forState:UIControlStateNormal];
    [self.authButton addTarget:self action:@selector(authenticate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.authButton];
}

- (void)setUpResultsTextView {
    self.authResultsTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, 105, 250, 125)];
    self.authResultsTextView.backgroundColor = [UIColor lightGrayColor];
    self.authResultsTextView.textAlignment = NSTextAlignmentLeft;
    self.authResultsTextView.text = @"Authentication Request Results";
    [self.view addSubview:self.authResultsTextView];
}

- (void)setUpUnauthedRequestButton {
    self.unauthedRequestButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.unauthedRequestButton.frame = CGRectMake(25, 300, 225, 30);
    self.unauthedRequestButton.backgroundColor = [UIColor greenColor];
    self.unauthedRequestButton.layer.cornerRadius = 10;
    self.unauthedRequestButton.titleLabel.textColor = [UIColor blackColor];
    [self.unauthedRequestButton setTitle:@"Send Unauthed Request" forState:UIControlStateNormal];
    [self.unauthedRequestButton addTarget:self action:@selector(blogInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.unauthedRequestButton];
}

@end
