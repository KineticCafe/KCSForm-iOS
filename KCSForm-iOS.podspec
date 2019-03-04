Pod::Spec.new do |s|
  s.name             = 'KCSForm-iOS'
  s.version          = '1.0.0'
  s.summary          = 'KCS Form is a library to help you build iOS UI forms using pre-built input types.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/KineticCafe/KCSForm-iOS'
  s.author           = { 'Kinetic Commerce' => 'info@kineticcommerce.com' }
  spec.license      = { :type => 'MIT' }
  s.source           = { :git => 'git@github.com:KineticCafe/KCSForm-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'KCSForm-iOS/Classes/**/*'
  
  s.resources = ['KCSForm-iOS/Assets/*.bundle']
  s.dependency 'IQKeyboardManager'
  s.dependency 'DropDown'
end
