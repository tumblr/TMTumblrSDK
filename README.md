# Tumblr SDK for iOS
A full Tumblr API client built on the lightweight [JXHTTP](https://github.com/jstn/JXHTTP) networking library by [Justin Ouellette](https://github.com/jstn).

## Usage
Import **TMTumblrSDK.h**. Configure `[TMAPIClient sharedInstance]` with your:

* Tumblr API key
* OAuth token
* OAuth token secret
* OAuth consumer key
* OAuth consumer secret


## Unit tests
A full unit test suite can be found in **Tests/TumblrSDKTests.m** and can be run from the Xcode project file's **Tests** target. By default, tests for POST requests (e.g. creating a post, liking a post, or following a user) are commented out.

To run unit tests, set the `defaultBlogName` property in TumblrSDKTests.m and update **Tests/Credentials.plist** with your:

* Tumblr API key
* OAuth token
* OAuth token secret
* OAuth consumer key
* OAuth consumer secret
