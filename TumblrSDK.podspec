Pod::Spec.new do |s|
  s.name         = 'TumblrSDK'
  s.version      = '0.1.0'
  s.author       = { 'Bryan Irace' => 'bryan@tumblr.com' }
  s.source_files = 'TumblrSDK'
  s.frameworks   = 'Foundation'
  s.dependency 'JXHTTP', :git => "git://github.com/tumblr/JXHTTP"
  s.dependency 'TumblrAuthentication', :git => "git://github.com/tumblr/tumblr-ios-authentication"
end
