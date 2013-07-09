post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 
    'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

pod 'CocoaSoundCloudAPI', '1.0.1'
pod 'CocoaSoundCloudUI', '1.0.5'
pod 'NSObject+Expectation', '0.2'
pod 'AFNetworking'
