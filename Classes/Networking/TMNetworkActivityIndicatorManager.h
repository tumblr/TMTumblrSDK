//
//  TMNetworkActivityIndicatorManager.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/7/16.
//
//

/**
 *  A protocol for types to conform to for updates on when the SDK determines if the network activity indicator should be visible.
 */
@protocol TMNetworkActivityIndicatorManager

/**
 *  Called when the SDK determines the network activity indicator should be visible.
 *
 *  @param networkActivityIndicatorVisible Whether or not the network activity indicator should be visible.
 */
- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible;

@end
