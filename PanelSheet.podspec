#
# Be sure to run `pod lib lint PanelSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PanelSheet'
  s.version          = '1.1.1'
  s.summary          = 'Drawer or Panel like action sheet.'
  s.description      = 'Drawer or Panel like action sheet. Written using Objective-C'

  s.homepage         = 'https://github.com/ibnusina/PanelSheet'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ibnusina' => 'ibnu.sina009@gmail.com' }
  s.source           = { :git => 'https://github.com/ibnusina/PanelSheet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'PanelSheet/Classes/*.{m,h}'
  
  s.resources = ['PanelSheet/Classes/*.{xib}']
  
  s.public_header_files = 'PanelSheet/Classes/*.h'
  s.frameworks          = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
