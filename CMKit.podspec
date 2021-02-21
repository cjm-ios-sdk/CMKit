#
# Be sure to run `pod lib lint CMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CMKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CMKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chenjm/CMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenjm' => 'cjiemin@163.com' }
  s.source           = { :git => 'https://github.com/chenjm/CMKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  
  # s.resource_bundles = {
  #   'CMKit' => ['CMKit/Assets/*.png']
  # }
      
  # 数学计算
  s.subspec 'Math' do |ss|
    ss.source_files = 'CMKit/Classes/Math/**/*'
  end
  
  # 数据库
  s.subspec 'Database' do |ss|
    ss.source_files = 'CMKit/Classes/Database/**/*'
    ss.dependency 'FMDB'
  end
  
  # 网络
  s.subspec 'Network' do |ss|
    ss.source_files = 'CMKit/Classes/Network/**/*'
  end
  
  # 路由
  s.subspec 'Router' do |ss|
    ss.source_files = 'CMKit/Classes/Router/**/*'
  end
  
  # 滚动页
  s.subspec 'Viewpager' do |ss|
    ss.source_files = 'CMKit/Classes/Viewpager/**/*'
    ss.dependency 'CMKit/Network'
  end
  
  # 顶部栏
  s.subspec 'TopBar' do |ss|
    ss.source_files = 'CMKit/Classes/TopBar/**/*'
  end
  
  # 定时器的扩展
  s.subspec 'Timer' do |ss|
    ss.source_files = 'CMKit/Classes/Timer/**/*'
  end
  
  # 视图的扩展
  s.subspec 'View' do |ss|
    ss.source_files = 'CMKit/Classes/View/**/*'
  end

  # 按钮的扩展
  s.subspec 'Button' do |ss|
    ss.source_files = 'CMKit/Classes/Button/**/*'
  end
  
  # 图片的扩展
  s.subspec 'Image' do |ss|
    ss.source_files = 'CMKit/Classes/Image/**/*'
  end
  
  # 颜色的扩展
  s.subspec 'Color' do |ss|
    ss.source_files = 'CMKit/Classes/Color/**/*'
  end
  
  # 警告框
  s.subspec 'AlertView' do |ss|
    ss.source_files = 'CMKit/Classes/AlertView/**/*'
  end
  
  # 提示框
  s.subspec 'ToastView' do |ss|
    ss.source_files = 'CMKit/Classes/ToastView/**/*'
    ss.dependency 'CMKit/Timer'
  end
    
  # 手势的扩展
  s.subspec 'GestureRecognizer' do |ss|
    ss.source_files = 'CMKit/Classes/GestureRecognizer/**/*'
  end
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
