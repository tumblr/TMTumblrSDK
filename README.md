# Tumblr SDK for iOS

An unopinionated and flexible library for easily integrating Tumblr data into
your iOS or OS X application. The library uses ARC and requires at least iOS 5 or
OS X 10.7.

If you have any feature requests, please let us know by creating an issue or
submitting a pull request. Please use the Tumblr API [responsibly](http://www.tumblr.com/docs/en/api_agreement).

## Table of Contents

* [Getting started](#getting-started)
    * [CocoaPods](#cocoapods)
    * [Documentation](#documentation)
* [Connecting to Tumblr](#connecting-to-tumblr)
    * [API client](#api-client)
      * [Authentication](#authentication)
    * [App client](#app-client)
    * [Other connection methods](#other-connection-methods)
* [Example App](#example)
* [Contact](#contact)
* [License](#license)

## Getting started

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add the Tumblr
SDK to your project. *Using CocoaPods means you don't need to worry about
cloning or adding this repository as a git submodule.* CocoaPods is a package
manager like `gem` (Ruby) and `npm` (Node.js), but for Objective-C projects.

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
platform :ios, '5.0'

pod 'TMTumblrSDK'
```

After running `pod install`, you'll have an Xcode workspace that includes not
only your application but also the Tumblr SDK and its dependencies. That's really
all there is to it.

You will get the latest version of the SDK by referring to it simply by name
(`TMTumblrSDK`). [This guide](http://docs.cocoapods.org/guides/dependency_versioning.html)
explains how explicit dependency versions can instead be specified.

This SDK is really comprised of numerous "sub-pods." If you'd rather not import
everything, feel free to mix and match as you see fit:

* `TMTumblrSDK/APIClient`
    * `TMTumblrSDK/APIClient/Authentication`
* `TMTumblrSDK/AppClient`

Each component is described in more detail throughout this README.

If you choose to include TMTumblrSDK (and as such, its dependencies) manually (i.e. without CocoaPods)
please make sure that your app can still read `TMTumblrSDK.podspec.json`. We use this for
tracking which versions of TMTumblrSDK are in use, which helps us make informed decisions
about the project’s future.

### Documentation

Appledoc for the SDK can be found [here](http://cocoadocs.org/docsets/TMTumblrSDK).
If you install the Tumblr SDK using CocoaPods, the docset is automatically added
to Xcode for you.

## Connecting to Tumblr

There are two ways for your application to connect with Tumblr, each with different benefits. You are free to choose the method that you prefer based on the needs of your application.

### API client

The first method is the API Client, a class that facilitates direct communication with Tumblr via the [Tumblr API](http://www.tumblr.com/docs/en/api/v2). The benefits of using the API Client include the ability to better control the user experience and keep users in your app. A typical use case for the API client is an application that allows a user to share a photo to multiple social networks at the same time. In this case, after allowing a user to select a photo, you might present them with a list of toggles representing the different networks that would receive the photo. Once they confirm, and assuming they selected Tumblr, you would use the API client to post the image to the user's Tumblr. Use of the API Client requires [authentication](#authentication) from the user for certain routes which you may facilitate through the `TMTumblrAuthenticator` class.

Please view the [API documentation](http://www.tumblr.com/docs/en/api/v2) for full usage instructions.

There are two ways of retrieving data from the API:

``` objectivec
// `void` methods for immediate requests, preferable when the caller does not need a reference to an actual request object:

[[TMAPIClient sharedInstance] userInfo:^(id result, NSError *error) {
    if (!error)
        NSLog(@"Got some user info");
}];

// Methods that return configured, signed `JXHTTPOperation` instances and require the client to explicitly send the request separately.

JXHTTPOperation *likesRequest = [[TMAPIClient sharedInstance] likesRequest:@"bryan" parameters:nil];
```

The API client is built on top of the
[JXHTTP](https://github.com/tumblr/JXHTTP) networking library. If you're only
interested in the API client, the `TMTumblrSDK/APIClient` sub-pod can be
installed by itself.

#### Authentication

Import `TMAPIClient.h`. Configure the `[TMAPIClient sharedInstance]` singleton
with your app’s Tumblr consumer key and secret:

``` objectivec
[TMAPIClient sharedInstance].OAuthConsumerKey = @"ADISJdadsoj2dj38dj29dj38jd9238jdk92djasdjASDaoijsd";
[TMAPIClient sharedInstance].OAuthConsumerSecret = @"MGI39kdasdoka3240989ASFjoiajsfomdasd39129ASDAPDOJa";
```

If you don't already have a consumer key/secret you can
register [here](http://www.tumblr.com/oauth/apps).

The authentication methods detailed below will provide the API client with a token and token secret. The
SDK does *not* currently persist these values; you are responsible for storing them and setting them on
the API client on subsequent app launches, before making any API requests. This may change in a future
release.

##### OAuth

In your app’s `Info.plist`, specify a custom URL scheme that the browser can
use to return to your application once the user has permitted or denied
access to Tumblr:

``` xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>myapp</string>
    </array>
  </dict>
</array>
```

In your app delegate, allow the `TMAPIClient` singleton to handle incoming URL requests.

On iOS this looks like:

``` objectivec
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}
```

OS X:

``` objectivec
- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:)
                                          forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    NSString *calledURL = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];

    [[TMAPIClient sharedInstance] handleOpenURL:[NSURL URLWithString:calledURL]];
}
```

Initiate the three-legged OAuth flow, by specifying the URL scheme that your app will respond to.

iOS:

``` objectivec
[[TMAPIClient sharedInstance] authenticate:@"myapp" fromViewController:controller
                                  callback:^(NSError *error) {
    // You are now authenticated (if !error)
}];
```

OS X:

``` objectivec
[[TMAPIClient sharedInstance] authenticate:@"myapp" callback:^(NSError *error) {
    // You are now authenticated (if !error)
}];
```

##### xAuth

Please note that xAuth access is no longer available to 3rd party developers.


If you're only interested in authentication, the
`TMTumblrSDK/APIClient/Authentication` sub-pod can be installed by itself.



### App client

The second method is the App Client, a class that allows you to facilate communication to Tumblr via the Tumblr App installed on the phone. The App Client provides a series of methods, each of which will launch the Tumblr App, passing the necessary parameters to perform a specific function. When launching the Tumblr app to make a post, the Tumblr App will return the user to your app if you include the correct success and cancel parameters. The benefit of the App Client is that it requires very little programming on your part and does not require any user authentication (they are already authenticated in the Tumblr App). In addition, it always uses the latest functionality in the Tumblr app to perform the desired function so you don't have to keep your app up to date. You might use the App Client when you want to enable a user to post an image to Tumblr using the post form in the Tumblr App, thus allowing them to edit the image using Tumblr's tools.


The `TMTumblrAppClient` class provides a simple interface for interacting with
[Tumblr for iOS](https://itunes.apple.com/us/app/tumblr/id305343404?mt=8) if the
user has it installed. The following methods are currently available. See the [AppleDoc](http://cocoadocs.org/docsets/TMTumblrSDK/4.0.4/Classes/TMTumblrAppClient.html#class_methods) for details of each.

```objc
+ isTumblrInstalled
+ viewInAppStore
+ viewDashboard
+ viewExplore
+ viewActivityForPrimaryBlog
+ viewActivity:
+ viewTag:
+ viewPrimaryBlog
+ viewBlog:
+ viewPost:blogName:
+ createTextPost:body:tags:
+ createTextPost:body:tags:success:cancel:
+ createQuotePost:source:tags:
+ createQuotePost:source:tags:success:cancel:
+ createLinkPost:URLString:description:tags:
+ createLinkPost:URLString:description:tags:success:cancel:
+ createChatPost:body:tags:
+ createChatPost:body:tags:success:cancel:
+ showAuthorizeWithToken:

```

The `showAuthorizeWithToken:` example allows you to kick off the OAuth
authorization step after obtaining a request token
(see [Authentication](https://www.tumblr.com/docs/en/api/v2#auth) section in the
docs). Make sure your redirect URLs are properly set in the API dashboard to
handle callbacks from this flow.

If you're only interested in the app client,
the `TMTumblrSDK/AppClient` sub-pod can be installed by itself.

#### Attribution and Deep Links

If your app posts to Tumblr, you can provide the API Client with deep link URLs under the keys `TMPostKeyDeepLinkiOS` and `TMPostKeyDeepLinkAndroid`. This will cause attribution UI for your app to be displayed beneath the post on the respective platform. When this UI is tapped, the OS will open the deep link you specified. Be aware that all icons and required fields must be provided in your app's [configuration](https://www.tumblr.com/oauth/apps) before this UI will be visible.

**NOTE:** This is currently only available to whitelisted app partners. Contact Tumblr business development ([bd@tumblr.com](mailto:bd@tumblr.com)) if your app requires this functionality.

### Other Connection Methods
#### URL schemes [Deprecated] - Developers who use the URL schemes should migrate to the [App Client](#app-client)
Apps that already make direct calls to Tumblr URL schemes will still work. Going forward, for App to App communications, use the App client.
#### UIActivityViewController [Deprecated]

## Example

The repository includes a [sample application](https://github.com/tumblr/TMTumblrSDK/tree/master/Examples/AppClientExample)
which shows all of the inter-app hooks in action.

## Dependencies

* [JXHTTP](https://github.com/tumblr/JXHTTP)

## Contact

* [Tumblr iOS](mailto:ios-engineering@tumblr.com)
* [Tumblr API discussion group](https://groups.google.com/group/tumblr-api/)

## License

Copyright 2012 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
> WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
> License for the specific language governing permissions and limitations under
> the License.
