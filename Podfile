# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
install! 'cocoapods', :disable_input_output_paths => true
platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!
target 'Weather' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Moya', '~> 15.0.0'
  pod 'ComposableArchitecture', '~> 0.8.0'

  target 'WeatherTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WeatherUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
