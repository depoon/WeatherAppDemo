platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

target 'WeatherApp' do
 pod 'AFNetworking', '2.6.3'
 pod 'MBProgressHUD'
 pod 'OHHTTPStubs', '~> 4.0', :configurations => ['Debug']
end

target 'WeatherAppTests' do
 pod 'Kiwi'
end

target 'WeatherAppUITests' do
 pod 'XCTest-Gherkin'
 pod 'XCTest-Gherkin/Native'
 pod 'JAMTestHelper', :git => 'https://github.com/depoon/JAMTestHelper.git', :branch => 'AddTimeouts'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    	if target.name == "JAMTestHelper" || target.name == "XCTest-Gherkin"
			config.build_settings['SWIFT_VERSION'] = '2.3'
			puts "- #{target.name} set to 2.3"
    	end
	end
  end
end

