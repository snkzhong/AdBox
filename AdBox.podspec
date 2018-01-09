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

  # s.source_files = 'codes/**/*','Static/**/*'
  s.source_files = 'Class'
  
  # s.resource_bundles = {
  #   'PodTest' => ['PodTest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.public_header_files   = 'Static/VungleAdNetworkExtras.h'
  # s.vendored_library = 'Static/libVungleAdapter.a'
  # s.public_header_files = 'AdFramework/**/*.{h}'
  #s.vendored_frameworks = 'AdFramework/Chartboost.framework','AdFramework/ChartboostAdapter.framework','AdFramework/GoogleMobileAds.framework','AdFramework/UMMobClick.framework','AdFramework/UMOnlineConfig.framework','AdFramework/UnityAdapter.framework','AdFramework/UnityAds.framework','AdFramework/VungleSDK.framework'
  s.frameworks = "WebKit", "AdSupport", "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreTelephony", "EventKitUI", "EventKit", "StoreKit", "SystemConfiguration", "GLKit", "CoreMotion", "SafariServices", "MobileCoreServices", "CoreBluetooth", "MediaPlayer"
  s.libraries = "sqlite3", "z"
  # s.dependency 'AFNetworking', '~> 2.3'
end

