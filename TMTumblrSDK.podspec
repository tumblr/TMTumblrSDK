Pod::Spec.new do |s|
  s.name         = 'TMTumblrSDK'
  s.version      = '1.0.0'
  s.summary      = 'An unopinionated and flexible library for easily integrating Tumblr data into your iOS or OS X application'
  s.author       = { 'Bryan Irace' => 'bryan@tumblr.com' }
  s.license      = 'Apache 2.0'
  s.source_files = 'TMTumblrSDK'
  s.resources    = 'TMTumblrSDK/*.{png}'
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.frameworks   = 'Foundation'

  s.subspec 'Authentication' do |ss|
    ss.source_files = 'TMTumblrSDK/Authentication'
    ss.dependency   'NSData+Base64', '1.0'
  end

  s.subspec 'APIClient' do |ss|
    ss.source_files = 'TMTumblrSDK/APIClient'
    ss.dependency   'JXHTTP', :git => "git@github.com:tumblr/JXHTTP.git"
    ss.dependency   'TMTumblrSDK/Authentication'
  end

  s.subspec 'AppClient' do |ss|
    ss.platform     = :ios, '5.0'
    ss.source_files = 'TMTumblrSDK/AppClient'
    ss.dependency   'InterAppCommunication', '1.0'
  end

end
