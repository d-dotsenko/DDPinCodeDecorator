Pod::Spec.new do |spec|

	spec.name 		= "DDPinCodeDecorator"
	spec.platform 		= :ios
	spec.summary 		= "Pin Code Decorator allows you to create a awesome controller for entering password and PIN."
	spec.requires_arc 	= true
	spec.version 		= "0.0.1"
	spec.license 		= { :type => "MIT", :file => "LICENSE" }	
	spec.author 		= { "Dmitriy Dotsenko" => "d.dotsenko@icloud.com" }
	spec.homepage 		= "https://github.com/d-dotsenko/DDPinCodeDecorator"
	spec.source 		= { :git => "https://github.com/d-dotsenko/DDPinCodeDecorator.git", :tag => "#{spec.version}" }
	spec.frameworks 	= "UIKit"
	spec.source_files 	= "PinCodeDecorator/**/*.{h,swift}"
	spec.swift_version 	= "5"
	spec.ios.deployment_target 	= "10"
end
