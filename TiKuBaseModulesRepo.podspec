#
# Be sure to run `pod lib lint TiKuBaseModulesRepo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TiKuBaseModulesRepo'
  s.version          = '0.3.5'
  s.summary          = 'TiKuBaseModulesRepo'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  0.2.3 --- 基础类
  0.2.8 --- +基础类
  0.2.9 --- +控件基础类
  
                       DESC

  s.homepage         = 'https://github.com/JeeneDo/BX_TiKuBaseModulesRepo.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zhang Xin Xin' => 'shou1wang@gmail.com' }
  s.source           = { :git => 'https://github.com/JeeneDo/BX_TiKuBaseModulesRepo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'TiKuBaseModulesRepo/Classes/**/*'
  s.libraries = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => "$(SDKROOT)/usr/include/libxml2" }
  
  s.dependency "BaseClassModulesRepo", '~> 0.1.6'
  s.dependency "SDWebImage"


  # s.resource_bundles = {
  #   'TiKuBaseModulesRepo' => ['TiKuBaseModulesRepo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
