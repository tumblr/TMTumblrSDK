Pod::Spec.new do |s|
  s.name         = 'TumblrSDK'
  s.version      = '1.0.0'
  s.summary      = 'An unopinionated and flexible library for easily integrating Tumblr data into your iOS or OS X application'
  s.author       = { 'Bryan Irace' => 'bryan@tumblr.com' }
  s.license      = 'Apache 2.0'
  s.source_files = 'TumblrSDK'
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.frameworks   = 'Foundation'
  s.dependency 'TumblrAuthentication', :git => "git@github.com:tumblr/tumblr-ios-authentication.git"
  s.dependency 'TumblrAppClient', :git => "git@github.com:tumblr/tumblr-ios-app-client.git"
  s.dependency 'JXHTTP', :git => "git@github.com:tumblr/JXHTTP.git"
end
