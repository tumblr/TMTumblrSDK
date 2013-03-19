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

  s.subspec 'APIClient' do |api|
    api.source_files = 'TMTumblrSDK/APIClient'
    api.dependency   'JXHTTP', :git => "git@github.com:tumblr/JXHTTP.git"
    api.dependency   'Authentication'
  end

  s.subspec 'Authentication' do |auth|
    auth.source_files = 'TMTumblrSDK/Authentication'
    auth.dependency   'NSData+Base64', '1.0'
  end

  s.subspec 'AppClient' do |tac|
    tac.platform     = :ios, '5.0'
    tac.source_files = 'TMTumblrSDK/AppClient'
    tac.dependency   'InterAppCommunication', '1.0'
  end

end
