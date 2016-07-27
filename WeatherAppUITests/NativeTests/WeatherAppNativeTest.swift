//
//  WeatherAppNativeTest.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 24/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import XCTest
import XCTest_Gherkin

class WeatherAppNativeTest: NativeTestCase {
        
    override func setUp() {
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        self.path = bundle.resourceURL?.URLByAppendingPathComponent("SearchWeatherForCity.feature")
        
        XCTAssertNotNil(self.path)
        
        XCUIApplication().launch()
    }
    
}
