//
//  TMTumblrActivity.h
//  TumblrAppClient
//
//  Created by Bryan Irace on 3/19/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `TMTumblrActivity` provides the bare minimum `UIActivity` subclass necessary to start sharing to Tumblr: just the name
 and icon.
 
 For now this is essentially a blank canvas to be used in conjunction with either `TMAPIClient` or `TMTumblrAppClient`.
 This should be subclassed in accordance with the `UIActivity` documentation to actually perform an action based on
 provided activity items. In the future we may provide a more integrated solution.
 */
@interface TMTumblrActivity : UIActivity

@end
