# Tumblr SDK for iOS

    [[TMAPIClient sharedInstance] blogInfo:@"bryan" success:^ (id result, NSError *error) {
    	if (error) {
	        NSLog(@"Bummer, dude: %@", error);
	        return;    		
    	}

		NSLog(@"Blog description: %@", result[@"description"]);
    }];

Unopinionated and flexible SDK for easily integrating Tumblr data into your application, however you see fit.
    
Built on top of Justin Ouellette's lightweight [JXHTTP](https://github.com/jstn/JXHTTP) networking library.

## Getting started
[CocoaPods](http://cocoapods.org) is the recommended way to add the Tumblr iOS SDK to your project. You can simply create a [podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile) that looks as follows:

    platform :ios, '5.0'

    pod 'TumblrSDK', '0.1.0'

## Usage
Import `TMTumblrSDK.h`. Configure the `TMAPIClient` singleton with your app’s Tumblr consumer key and secret:

    [TMAPIClient sharedInstance].OAuthConsumerKey = @"ADISJdadsoj2dj38dj29dj38jd9238jdk92djasdjASDaoijsd";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"MGI39kdasdoka3240989ASFjoiajsfomdasd39129ASDAPDOJa";

### Authentication
The SDK proxies to the [TumblrAuthentication](https://github.com/tumblr/tumblr-ios-authentication) module to provide both three-legged OAuth and xAuth flows. Please see the TumblrAuthentication [documentation](https://github.com/tumblr/tumblr-ios-authentication#usage) for instructions on how to implement authentication. Use the `[TMAPIClient sharedInstance]` singleton instead of `[TMTumblrAuthenticator sharedInstance]`.

### API client

Instances of `TMAPIClient` wrap all of the [Tumblr API](http://www.tumblr.com/docs/en/api/v2)'s endpoints. Please view the API documetation for usage instructions and available parameters.

The API client provides two ways of hitting the API:

* `void` methods that send requests and invoke a callback upon receiving a response. Preferred when the consumer does not care to modify underlying HTTP request operation:

	[[TMAPIClient sharedInstance] userInfo:^(id result, NSError *error) {
		if (!error) NSLog(@"Got some user info");
	}];

* Methods that return a configured, signed `JXHTTPOperation` and require the client to explicitly send the request in a second step. This is useful if you want a reference to the request object:

	JXHTTPOperation *likesRequest = [[TMAPIClient sharedInstance] likesRequest:@"bryan" parameters:nil];

	// TODO: Observe some properties, store the request in an instance variable so it can be cancelled if the view controller is deallocated, etc.

	[[TMAPIClient sharedInstance] sendRequest:likesRequest callback:^(id result, NSError *error) {
		if (!error) NSLog(@"Got some liked posts");
	}];

## Unit tests
By default, non-idempotent tests (e.g. creating a post, liking a post, following a user) are commented out. To run the test target, create a `Tests/Credentials.plist` file with the following properties:

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

## License
Copyright 2012 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.