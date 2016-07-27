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

