//
//  WeatherDetailsPage.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation
import XCTest
import JAMTestHelper

struct WeatherDetailsPage{
    init(testCase: XCTestCase){
        testCase.waitForElementToExist(
            XCUIApplication().staticTexts["Weather Forecast"], 
            timeout: 5
        )
    }
}
