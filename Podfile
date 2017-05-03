# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
workspace 'BloodNoteFinal.xcworkspce'

target 'BloodNoteFinal' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'


  target 'BloodNoteFinalTests' do
    inherit! :search_paths
    pod 'Firebase'
    pod 'Firebase/Database'
    pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'
    # Pods for testing
    
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
        
  end

end
