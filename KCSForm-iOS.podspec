Pod::Spec.new do |s|
  s.name             = 'KCSForm-iOS'
  s.version          = '1.0.8'
  s.summary          = 'KCS Form is a library to help you build iOS UI forms using pre-built input types.'

  s.description      = <<-DESC
KCS Form is a library to help you build iOS UI forms using pre-built input types. The SDK is easy to use and easy to style to make form creation effortless.
                       DESC

  s.homepage         = 'https://github.com/KineticCafe/KCSForm-iOS'
  s.author           = { 'Kinetic Commerce' => 'info@kineticcommerce.com' }
  s.license          = { :type => 'MIT' }
  s.source           = { :git => 'https://github.com/KineticCafe/KCSForm-iOS.git', :tag => s.version.to_s }

  s.swift_version = '4.0'
  s.ios.deployment_target = '11.0'

  s.source_files = 'KCSForm-iOS/Classes/**/*'
  
  s.resources = ['KCSForm-iOS/Assets/*.bundle']
  s.dependency 'IQKeyboardManager'
  s.dependency 'DropDown'
end
