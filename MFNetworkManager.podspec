#
# Be sure to run `pod lib lint MFNetworkManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFNetworkManager'
  s.version          = '0.2.1'
  s.summary          = 'MFNetworkManager is a high level request util based on AFNetworking..'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/GodzzZZZ/MFNetworkManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GodzzZZZ' => 'GodzzZZZ@qq.com' }
  s.source           = { :git => 'https://github.com/GodzzZZZ/MFNetworkManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MFNetworkManagerDemo/MFNetworkManagerDemo/MFNetworkManager/*.{h,m}'
  
  # s.resource_bundles = {
  #   'MFNetworkManager' => ['MFNetworkManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = "UIKit", "Foundation", "ImageIO", "MobileCoreServices"
  s.dependency 'AFNetworking'
  s.dependency 'RealReachability'
end
