# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'sf_diplom' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for sf_diplom
  pod 'RealmSwift', '~>10.43.1'
  pod 'SDWebImage', '~>5.18.3'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'SnapKit', '~>5.6.0'
  pod 'MarqueeLabel/Swift'
  pod 'ObjectMapper'
  pod 'AlamofireObjectMapper'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        end
    end
End