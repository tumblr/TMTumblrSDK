# Tumblr SDK for iOS

An unopinionated and flexible library for easily integrating Tumblr data into
your iOS or OS X application. The library uses ARC requires at least iOS 10 or OS X 10.12.

If you have any feature requests, please let us know by creating an issue or
submitting a pull request. Please use the Tumblr API responsibly and adhere to the [Application Developer and API License Agreement](http://www.tumblr.com/docs/en/api_agreement).

## Table of Contents

* [Getting started](#getting-started)
    * [CocoaPods](#cocoapods)
    * [Documentation](#documentation)
* [Connecting to Tumblr](#connecting-to-tumblr)
    * [API client](#api-client)
    * [Authentication](#authentication)
         * [OAuth](#oauth) 
    * [Attribution and Deep Links](#attribution-and-deep-links)
    * [Share extension](#share-extension)
    * [Deprecated Connection Methods](#deprecated-connection-methods)
* [Example App](#example)
* [Contact](#contact)
* [License](#license)

## Getting started

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add the Tumblr
SDK to your project. *Using CocoaPods means you don't need to worry about
cloning or adding this repository as a git submodule.* CocoaPods is a package
manager like `gem` (Ruby) and `npm` (Node.js), but for Swift and Objective-C projects.

Module authors create "pods" which are versioned and stored in a central
repository. App developers create "podfiles" to specify their apps'
dependencies and use the CocoaPods command line tool to:

* Fetch the dependencies specified in their podfile
* Recursively fetch all subdependencies
* Create an Xcode workspace that includes the pods, links any necessary libraries,
configures header search paths, enables ARC where appropriate, and more

If you're new to CocoaPods, the website contains lots of helpful [documentation](http://docs.cocoapods.org).

To install the Tumblr SDK you can simply create a
[podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)
in your application's root directory that looks as follows:

``` ruby
platform :ios, '10.0'

pod 'TMTumblrSDK'
```

After running `pod install`, you'll have an Xcode workspace that includes not
only your application but also the Tumblr SDK. That's really all there is to it.

You will get the latest version of the SDK by referring to it simply by name
(`TMTumblrSDK`). [This guide](http://docs.cocoapods.org/guides/dependency_versioning.html)
explains how explicit dependency versions can instead be specified.

If you choose to include TMTumblrSDK manually (i.e. without CocoaPods)
please make sure that your app can still read `TMTumblrSDK.podspec.json`. We use this for
tracking which versions of TMTumblrSDK are in use, which helps us make informed decisions
about the project’s future.

### Documentation

Appledoc for the SDK can be found [here](http://cocoadocs.org/docsets/TMTumblrSDK).
If you install the Tumblr SDK using CocoaPods, the docset is automatically added
to Xcode for you.

## Connecting to Tumblr

### API client

Use the `TMAPIClient` class for communication with Tumblr via the [Tumblr API](http://www.tumblr.com/docs/en/api/v2). A typical use case for the API client is an application that allows a user to share a photo to multiple social networks at the same time. In this case, after allowing a user to select a photo, you might present them with a list of toggles representing the different networks that would receive the photo. Once they confirm, and assuming they selected Tumblr, you would use the API client to post the image to the user's Tumblr. Use of the API Client requires authentication from the user for certain routes which you may facilitate through the `TMOAuthAuthenticator` class.

Please view the [API documentation](http://www.tumblr.com/docs/en/api/v2) for full usage instructions.

### OAuth Authentication

In your `AppDelegate`,  import `<TMTumblrSDK/TMOAuthAuthenticator.h>`, `<TMTumblrSDK/TMURLSession.h>`, and `TMOAuthAuthenticatorDelegate.h`. 

Declare constants for your app’s Tumblr consumer key and secret:

``` objectivec
NSString * const OAuthTokenConsumerKey = @"";
NSString * const ConsumerSecret = @"";
```

If you don't already have a consumer key/secret you can
register [here](http://www.tumblr.com/oauth/apps).


#### Setup

In your app’s `Info.plist`, specify a custom URL scheme that the browser can
use to return to your application once the user has permitted or denied
access to Tumblr:

``` xml
        <key>CFBundleURLTypes</key>
        <array>
                <dict>
                        <key>CFBundleTypeRole</key>
                        <string>Editor</string>
                        <key>CFBundleURLName</key>
                        <string>com.tumblr.example</string>
                        <key>CFBundleURLSchemes</key>
                        <array>
                                <string>my-sample-app</string>
                        </array>
                </dict>
        </array>
```

In your app delegate setup your `TMURLSession` and `TMOAuthAuthenticator` instances, for example:

``` objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.applicationCredentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:OAuthTokenConsumerKey consumerSecret:ConsumerSecret];

    self.session = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                        applicationCredentials:self.applicationCredentials
                                               userCredentials:[TMAPIUserCredentials new]
                                        networkActivityManager:nil
                                     sessionTaskUpdateDelegate:nil
                                        sessionMetricsDelegate:nil
                                            requestTransformer:nil
                                             additionalHeaders:nil];

    self.authenticator = [[TMOAuthAuthenticator alloc] initWithSession:self.session
                                                applicationCredentials:self.applicationCredentials
                                                              delegate:self];

    ViewController *vc = [[ViewController alloc] initWithSession:self.session authenticator:self.authenticator];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}
```

Also add the ability to handle incoming URL requests and also conform to `TMOAuthAuthenticatorDelegate` 

On iOS this looks like:

``` objectivec
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self.authenticator handleOpenURL:url];
    return YES;
}

#pragma mark - TMOAuthAuthenticatorDelegate

- (void)openURLInBrowser:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}
```


Then, use these instances in an `authenticate` method in another class such as a view controller, for example

``` objectivec
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
```


### Attribution and Deep Links

If your app posts to Tumblr, you can provide the API Client with deep link URLs under the keys `TMPostKeyDeepLinkiOS` and `TMPostKeyDeepLinkAndroid`. This will cause attribution UI for your app to be displayed beneath the post on the respective platform. When this UI is tapped, the OS will open the deep link you specified. Be aware that all icons and required fields must be provided in your app's configuration before this UI will be visible.

**NOTE:** This is currently only available to whitelisted app partners. Contact Tumblr business development ([bd@tumblr.com](mailto:bd@tumblr.com)) if your app requires this functionality.

### Share extension

As of iOS 8, Tumblr for iOS ships with a share extension. It currently supports the following input types:

* Text
* Images (maximum: 10)
* Video (maximum: 1)
* URL (maximum: 1)

In the future, we hope to document specific ways for apps to pass parameters to be used for creating the different 
Tumblr post types, but we’d need to figure out a good way to do so that [won’t interfere with other share
extensions that could also potentially be displayed](https://github.com/tumblr/ios-extension-issues/issues/5).

If you're looking to hardcode some Tumblr-specific behavior, our share extension’s bundle identifier is **com.tumblr.tumblr.Share-With-Tumblr**.

### Deprecated Connection Methods
* URL schemes [Deprecated]
* UIActivityViewController [Deprecated]

## Example

The repository includes iOS and macOS sample applications.


## Contact

* [Tumblr iOS](mailto:ios-engineering@tumblr.com)
* [Tumblr API discussion group](https://groups.google.com/group/tumblr-api/)

## License

Copyright 2012-2017 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
> WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
> License for the specific language governing permissions and limitations under
> the License.
