test:
	xcodebuild -workspace TMTumblrSDK.xcworkspace -scheme TMTumblrSDKTests -sdk iphonesimulator TEST_AFTER_BUILD=YES clean build