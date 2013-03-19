# TumblrSDK
An unopinionated and flexible library for easily integrating Tumblr data into your iOS or OS X application, however you see fit. The library uses ARC and requires iOS 5 or OS X 10.7.

    [[TMAPIClient sharedInstance] blogInfo:@"bryan" success:^ (id result, NSError *error) {
        if (error) {
          NSLog(@"Bummer, dude: %@", error);
          return;         
        }
        NSLog(@"Blog description: %@", result[@"description"]);
    }];

The primary features of the SDK currently include:

* xAuth and three-legged OAuth implementations
* [An full API client](#api-client)
* A `UIActivity` stub (for displaying a Tumblr button in a standard `UIActivityViewController`)
* [Inter-app communication support (if the user has the Tumblr iOS app installed)](#inter-app-communication)

Built on top of the [JXHTTP](https://github.com/jstn/JXHTTP) networking library.

## Getting started
[CocoaPods](http://cocoapods.org) is the recommended way to add TumblrSDK to your project. You can simply create a [podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile) that looks as follows:

    platform :ios, '5.0'

    pod 'TumblrSDK', '0.1.0'

## Usage

### API client

`TMAPIClient` is a full wrapper for the [Tumblr API](http://www.tumblr.com/docs/en/api/v2). Please view the API documetation for usage instructions, available parameters, etc.

Import `TMAPIClient.h`. Configure the `[TMAPIClient sharedInstance]` singleton with your app’s Tumblr consumer key and secret:

    [TMAPIClient sharedInstance].OAuthConsumerKey = @"ADISJdadsoj2dj38dj29dj38jd9238jdk92djasdjASDaoijsd";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"MGI39kdasdoka3240989ASFjoiajsfomdasd39129ASDAPDOJa";

The API client proxies to [TumblrAuthentication](https://github.com/tumblr/tumblr-ios-authentication) to provide both three-legged OAuth and xAuth flows. Please see the TumblrAuthentication [documentation](https://github.com/tumblr/tumblr-ios-authentication#usage) for usage instructions but opt to use `[TMAPIClient sharedInstance]` instead of `[TMTumblrAuthenticator sharedInstance]` directly.

There are two ways of retrieving data from the API:

    // void methods for immediate requests, preferable when the caller does not need a reference to the underlying request options:

    [[TMAPIClient sharedInstance] userInfo:^(id result, NSError *error) {
        if (!error) NSLog(@"Got some user info");
    }];

    // Methods that return configured, signed JXHTTPOperation instances and require the client to explicitly send the request separately.

    JXHTTPOperation *likesRequest = [[TMAPIClient sharedInstance] likesRequest:@"bryan" parameters:nil];

    // TODO: Observe some properties, store the request in an instance variable so it can be cancelled if the view controller is deallocated, etc.

    [[TMAPIClient sharedInstance] sendRequest:likesRequest callback:^(id result, NSError *error) {
        if (!error) NSLog(@"Got some liked posts");
    }];

#### Tests
The API client contains a full integration test suite. By default, non-idempotent tests (e.g. creating a post, liking a post, following a user) are commented out. To run the test target, create a `Tests/Credentials.plist` file with the following properties:

    <key>OAuthToken</key>
    <string>ADISJdadsoj2dj38dj29dj38jd9238jdk92djasdjASDaoijsd</string>
    <key>OAuthTokenSecret</key>
    <string>MGI39kdasdoka3240989ASFjoiajsfomdasd39129ASDAPDOJa</string>
    <key>OAuthConsumerKey</key>
    <string>d9238jdk92djasdjASDaoijsdADISJdadsoj2dj38dj29dj38j</string>
    <key>OAuthConsumerSecret</key>
    <string>oiajsfomdasd39129ASDAPDOJaMGI39kdasdoka3240989ASFj</string>
    <key>BlogName</key>
    <string>brydev</string>

### Inter-app communication

The SDK includes [TumblrAppClient](https://github.com/tumblr/tumblr-ios-app-client), a library for interacting with [Tumblr for iOS](https://itunes.apple.com/us/app/tumblr/id305343404?mt=8) if the user has it installed. Please see the TumblrAppClient [documentation](https://github.com/tumblr/tumblr-ios-app-client#usage) for usage instructions.

The app client library also includes a `UIActivity` stub for including Tumblr in a standard `UIActivityViewController`. The repository includes a [full sample application](https://github.com/tumblr/tumblr-ios-app-client/tree/master/TumblrAppClientSample) which shows all of the application's hooks in action, as well as how to share photos and videos using Apple's standard [`UIDocumentInteractionController`](http://developer.apple.com/library/ios/#documentation/UIKit/Reference/UIDocumentInteractionController_class/Reference/Reference.html).

## Roadmap
I'm using this project's [wiki](https://github.com/tumblr/tumblr-ios-sdk/wiki) page to keep track of a rough roadmap for the SDK. If you have any feature requests, please let me know by creating an issue or submitting a pull request.

## Contact
[Bryan Irace](http://irace.me)

## License
Copyright 2012 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
