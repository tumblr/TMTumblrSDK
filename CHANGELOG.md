# TMTumblrSDK changelog

## 6.1.3

* Allow an array as a top level response object

## 6.1.2

* Adds support for Swift Package Manager

## 2.1

* Adds a method for creating video posts from either embed codes or web URLs

## 2.0.2

* Adds version reporting to the default user-agent header

## 2.0.1

* Suppress unnecessary warning

## 2.0

* Remove three-legged OAuth support as per Apple policies

## 1.1.1

* Less restrictive JXHTTP versioning

## 1.1.0

* Base URL is now configurable

## 1.0.8

* Use `NSInteger` instead of `int`
* Use XCTest instead of OCUnit
* Fix `UIActivity` subclass instance method that was supposed to be a class method

## 1.0.7

* Fix a bug where state remaining from a previous login could result in a subsequent login request being signed with invalid tokens
* Fixed bug in example URL scheme
* Fixed debug compilation in Xcode 5

## 1.0.6
* Changed `id` return types to `instancetype
* Fixed issue where iOS 7-only SDK method was being used for Base64 encoding
* Added `UIActivityCategory` for Tumblr share activity when running on iOS 7

## 1.0.5
* Add new activity icons for iOS 7

## 1.0.4
* Add configurable request timeout property
