platform :ios, '7.0'

pod 'TMTumblrSDK', :path => 'TMTumblrSDK.podspec'

# Can't use podspec directive due to a bug: https://github.com/CocoaPods/CocoaPods/issues/928
# podspec :name => 'TMTumblrSDK.podspec'

target :test, :exclusive => true do
    link_with 'TMTumblrSDKTests'
    pod 'OCMock'
end
