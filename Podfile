platform :ios, '5.0'

pod 'TMTumblrSDK', :local => 'TMTumblrSDK.podspec'

# Can't use podspec directive due to a bug: https://github.com/CocoaPods/CocoaPods/issues/928
# podspec :name => 'TMTumblrSDK.podspec'

target :test, :exclusive => true do
    link_with 'TMTumblrSDKTests'
    pod 'OCMock'
end
