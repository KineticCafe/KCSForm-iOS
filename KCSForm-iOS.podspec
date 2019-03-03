Pod::Spec.new do |s|
  s.name             = 'KCSForm-iOS'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KCSForm-iOS.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://bitbucket.org/halogenmobile/kcsform-ios'
  s.author           = { 'Kinetic Commerce' => 'info@kineticcafe.com' }
  s.source           = { :git => 'git@bitbucket.org:halogenmobile/kcsform-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'KCSForm-iOS/Classes/**/*'
  
  s.resources = ['KCSForm-iOS/Assets/*.bundle']
  s.dependency 'IQKeyboardManager'
  s.dependency 'DropDown'
end
