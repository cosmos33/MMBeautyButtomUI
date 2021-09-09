# Uncomment the next line to define a global platform for your project
source 'https://github.com/cosmos33/MMSpecs.git'
source 'https://cdn.cocoapods.org/'
use_frameworks! :linkage=>:static
platform :ios, '11.0'

target 'MMBeautyBottomUI' do
  pod 'MMBeautyUI',:path=>'./'

  
  pod 'MMBeautyKit', '2.8.2-interact'
   pod 'MMBeautyMedia','2.8.1'
   pod 'MMCV','2.8.1'
   pod 'MetalPetal/Static', '1.13.0', :source => 'https://github.com/cosmos33/MMSpecs.git'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|

        target.build_configurations.each do |config|
            config.build_settings['PROVISIONING_PROFILE'] = ''
            config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
            config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
    end
end
