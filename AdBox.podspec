Pod::Spec.new do |s|
  s.name             = 'AdBox'
  s.version          = '0.1.0'
  s.summary          = 'AdBox.'

  s.description      = <<-DESC
Ad Package, admob unity vungle chartboost.
                       DESC

  s.homepage         = 'https://github.com/snkzhong/AdBox'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'snkzhong@gmail.com' => 'snkzhong@gmail.com' }
  s.source           = { :git => 'https://github.com/snkzhong/AdBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'codes/**/*'
  
  # s.resource_bundles = {
  #   'PodTest' => ['PodTest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  ss = "WebKit", "AdSupport", "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreTelephony", "EventKitUI", "EventKit", "StoreKit", "SystemConfiguration", "GLKit", "CoreMotion", "SafariServices", "MobileCoreServices", "CoreBluetooth", "MediaPlayer", "libsqlite3.tbd", "libz.tbd"
  # s.dependency 'AFNetworking', '~> 2.3'
end
