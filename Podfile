# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ezygo-Driver' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ezygo-Driver
pod 'IQKeyboardManagerSwift'
pod 'Alamofire'
pod 'SDWebImage', '4.4.6'
pod 'M13Checkbox'
pod 'Crashlytics'
pod 'ACFloatingTextfield-Swift'
pod 'IQDropDownTextField'
pod 'BFKit-Swift'
pod 'DropDown'
pod 'Fabric'
pod 'CardIO'
pod 'GoogleMaps','3.0.3'
pod 'GooglePlaces','3.0.3'
#pod 'GooglePlacePicker'
pod 'SideMenuController' #0.2.4
pod 'NVActivityIndicatorView'
pod 'FloatRatingView'

pod 'MarqueeLabel/Swift'
pod 'Socket.IO-Client-Swift', '13.3.0'
pod 'SRCountdownTimer'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'TTSegmentedControl'
pod 'MBCircularProgressBar'
pod 'ActionSheetPicker-3.0'
pod 'Sheeeeeeeeet'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
