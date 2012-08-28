# Tumblr SDK for iOS

    [[TMAPIClient sharedInstance] blogInfo:@"bryan" success:^ (id result) {
        NSLog(@"Blog description: %@", result[@"description"]);
    } error:^ (NSError *error) {
        NSLog(@"Bummer, dude: %@", error);
    }];
    
The Tumblr SDK for iOS is built on Justin Ouellette's lightweight [JXHTTP](https://github.com/jstn/JXHTTP) networking library.

## Usage
See the official [Tumblr API documentation](http://www.tumblr.com/docs/en/api/v2) for usage instructions.

Import **TMTumblrSDK.h**. Configure `[TMAPIClient sharedInstance]` with your:

* Tumblr API key
* OAuth token
* OAuth token secret
* OAuth consumer key
* OAuth consumer secret


## Unit tests
A full unit test suite can be found in **Tests/TumblrSDKTests.m** and can be run from the Xcode project file's **Tests** target. By default, tests for POST requests (e.g. creating a post, liking a post, or following a user) are commented out.

To run the tests, set the `defaultBlogName` property in TumblrSDKTests.m and update **Tests/Credentials.plist** with your:

* Tumblr API key
* OAuth token
* OAuth token secret
* OAuth consumer key
* OAuth consumer secret

## License
Freely available for use under the MIT license: [http://bryan.mit-license.org](http://bryan.mit-license.org)