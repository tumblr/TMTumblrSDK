# Tumblr SDK for iOS

An unopinionated and flexible library for easily integrating Tumblr data into
your iOS or OS X application. The library uses ARC and requires at least iOS 5 or
OS X 10.7.

``` objectivec
[[TMAPIClient sharedInstance] blogInfo:@"bryan" success:^(id result, NSError *error) {
    if (error) {
      NSLog(@"Bummer, dude: %@", error);
      return;
    }

    NSLog(@"Blog description: %@", result[@"description"]);
}];
```

If you have any feature requests, please let us know by creating an issue or
submitting a pull request. Please use the Tumblr API [responsibly](http://www.tumblr.com/docs/en/api_agreement).

## Table of Contents

* [Getting started](#getting-started)
    * [CocoaPods](#cocoapods)
    * [Documentation](#documentation)
* [Authentication](#authentication)
    * [OAuth](#oauth-os-x-only)
    * [xAuth](#xauth)
* [API client](#api-client)
* [Inter-app communication](#inter-app-communication)
    * [App client](#app-client)
        * [URL schemes](#url-schemes)
    * [Share extension](#share-extension)
    * [UIActivityViewController](#uiactivityviewcontroller)
    * [Example](#example)
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
* `TMTumblrSDK/Activity`


Each component is described in more detail throughout this README.

If you choose to include TMTumblrSDK (and as such, its dependencies) manually (i.e. without CocoaPods)
please make sure that your app can still read `TMTumblrSDK.podspec.json`. We use this for
tracking which versions of TMTumblrSDK are in use, which helps us make informed decisions
about the project’s future.

### Documentation

Appledoc for the SDK can be found [here](http://cocoadocs.org/docsets/TMTumblrSDK).
If you install the Tumblr SDK using CocoaPods, the docset is automatically added
to Xcode for you.

## Authentication

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

### OAuth (OS X only)

Unfortunately, [Apple has started rejecting apps](https://github.com/tumblr/TMTumblrSDK/issues/67#issuecomment-59384303) 
that use three-legged OAuth via Safari, the preferred way to retrieve access tokens from a security perspective. For 
the time being, please either:

* [Request xAuth access](http://www.tumblr.com/oauth/apps)
* Use a web view inside of your application (here's [a TMTumblrSDK fork](https://github.com/felixmo/TMTumblrSDK/) 
that adds this capability, we may add it to the SDK proper at a later date)

We hope to have more to share on this note shortly.

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

In your app delegate, allow the `TMAPIClient` singleton to handle incoming URL
requests.

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

Initiate the three-legged OAuth flow, by specifying the URL scheme that your
app will respond to:

``` objectivec
[[TMAPIClient sharedInstance] authenticate:@"myapp" callback:^(NSError *error) {
    // You are now authenticated (if !error)
}];
```

### xAuth

Please note that xAuth access
[must be specifically requested](http://www.tumblr.com/oauth/apps)
for your application.

Use the `TMAPIClient` singleton to retrieve an OAuth token and secret given a
user’s email address and password:

``` objectivec
[[TMAPIClient sharedInstance] xAuth:@"foo@foo.bar" password:@"12345" callback:^(NSError *error) {
    // You are now authenticated (if !error)
}];
```

If you're only interested in authentication, the
`TMTumblrSDK/APIClient/Authentication` sub-pod can be installed by itself.

## API client

Please view the [API documentation](http://www.tumblr.com/docs/en/api/v2) for
full usage instructions.

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
[JXHTTP](https://github.com/jstn/JXHTTP) networking library. If you're only
interested in the API client, the `TMTumblrSDK/APIClient` sub-pod can be
installed by itself.

## Inter-app communication

### App client

The `TMTumblrAppClient` class provides a simple interface for interacting with
[Tumblr for iOS](https://itunes.apple.com/us/app/tumblr/id305343404?mt=8) if the
user has it installed. Only a few basic endpoints are supported for now but more
will be added in the near future:

```objc
if (![TMTumblrAppClient isTumblrInstalled]) {
    [TMTumblrAppClient viewInAppStore];
}

[TMTumblrAppClient viewDashboard];

[TMTumblrAppClient viewTag:@"gif"];

[TMTumblrAppClient viewBlog:@"bryan"];

[TMTumblrAppClient viewPost:@"43724939726" blogName:@"bryan"];

[TMTumblrAppClient showAuthorizeWithToken:@"AnOAuthToken"];
```

The `showAuthorizeWithToken:` example allows you to kick off the OAuth 
authorization step after obtaining a request token 
(see [Authentication](https://www.tumblr.com/docs/en/api/v2#auth) section in the
docs). Make sure your redirect URLs are properly set in the API dashboard to
handle callbacks from this flow.

If you're only interested in the app client,
the `TMTumblrSDK/AppClient` sub-pod can be installed by itself.

#### URL schemes

Tumblr for iOS exposes actions using the [x-callback-url](http://x-callback-url.com/)
specification. The `TMTumblrAppClient` class merely provides a convenient 
interface on top of the following URLs:

```
tumblr://x-callback-url/dashboard
tumblr://x-callback-url/explore
tumblr://x-callback-url/activity
tumblr://x-callback-url/activity?blogName=bryan
tumblr://x-callback-url/tag?tag=gif
tumblr://x-callback-url/blog
tumblr://x-callback-url/blog?blogName=bryan
tumblr://x-callback-url/blog?blogName=bryan&postID=43724939726

// The post URLs below also support `x-success` and `x-cancel` callback parameters

tumblr://x-callback-url/text?title=Title&body=Body&tags=gif&tags=lol
tumblr://x-callback-url/quote?quote=Quote&source=Source
tumblr://x-callback-url/link?title=Bryan&url=bryan.io&description=Website
tumblr://x-callback-url/chat?title=Title&body=Body&tags=gif&tags=lol

// Will create a post using images from `[UIPasteboard generalPasteboard].images`
tumblr://x-callback-url/photo?caption=Caption&tags=gif&tags=lol
```

If you don't want to use this SDK and would rather hit these URLs directly, please go
right ahead.

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

### UIActivityViewController

**Note: As of iOS 8, it’s preferable to just allow your users to use our share extension instead. To share to Tumblr directly without using our extension, please use our [URL schemes](#url-schemes).**

The SDK includes a [UIActivity subclass](https://github.com/tumblr/TMTumblrSDK/blob/master/TMTumblrSDK/Activity/TMTumblrActivity.h) 
for including Tumblr in a standard `UIActivityViewController`. It currently 
provides only the activity icon and title, but you can hook it up however you 
see fit and we may provide a more integrated solution in the future.

If you're only interested in this UIActivity subclass,
the `TMTumblrSDK/Activity` sub-pod can be installed by itself.

### Example

The repository includes a [sample application](https://github.com/tumblr/TMTumblrSDK/tree/master/Examples/AppClientExample)
which shows all of the inter-app hooks in action.

## Dependencies

* [JXHTTP](https://github.com/jstn/JXHTTP)

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
