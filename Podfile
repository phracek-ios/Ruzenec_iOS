platform :ios, '10.0'
inhibit_all_warnings!

target 'RuzeneciOS' do
	use_frameworks!

  pod 'Firebase/Analytics'
	pod 'BonMot'
end

post_install do |installer|
 # add these lines:
 installer.pods_project.build_configurations.each do |config|
  config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "armv7"
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
 end
  
 installer.pods_project.targets.each do |target|
   
  # add these lines:
  target.build_configurations.each do |config|
   if Gem::Version.new($iOSVersion) > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
   end
   if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
     xcconfig_path = config.base_configuration_reference.real_path
     IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
   end
  end
   
 end
 installer.aggregate_targets.each do |target|
   target.xcconfigs.each do |variant, xcconfig|
     xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
     IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
   end
 end
end
