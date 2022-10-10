# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyVagon' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for MyVagon
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'FittedSheets', '~>2.0.0'
  pod 'DropDown'
  pod 'UIView-Shimmer', '~> 1.0'
  pod 'lottie-ios'
  pod 'GooglePlacePicker'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'FSCalendar'
  pod 'GrowingTextView', '0.7.2'
  pod 'Cosmos', '~> 23.0'
  pod 'Charts'
  pod 'Socket.IO-Client-Swift', '13.3.1'
  pod 'SwiftMessages'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['LD_NO_PIE'] = 'NO'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
        config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
      end
    end
  end
end
