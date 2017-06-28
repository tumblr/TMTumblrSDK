//
//  TMWebViewController.h
//  TumblrAuthentication
//
//  Created by Sergey Shpuntov on 3/11/16.
//  Copyright (c) 2016 Tumblr. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED

#import <UIKit/UIKit.h>

@protocol TMWebViewControllerDelegate;

@interface TMWebViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak) id<TMWebViewControllerDelegate> delegate;

@end

@protocol TMWebViewControllerDelegate <NSObject>
@optional

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller should be dismissed by caller. */
- (void)webViewControllerDidFinish:(TMWebViewController *)controller;

@end

#endif
