//
//  WeatherSearchPage.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation
import XCTest
import JAMTestHelper

struct WeatherSearchPage{
    init(testCase: XCTestCase){
        testCase.waitForElementToExist(
            XCUIApplication().otherElements["WeatherSearchPage"],
            timeout: 5
        )
    }
    
    func userSearchForCity(city: String){
        let app = XCUIApplication()
        let searchField = app.searchFields["Search a city"]
        searchField.tap()
        searchField.waitForKeyboardThenTypeText(city)
        app.buttons["Search"].tap()
    }
    
}

extension XCUIElement {
    
    //To fix - "UI Testing Failure - Neither element nor any descendant has keyboard focus."
    func waitForKeyboardThenTypeText(text: String){
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            self.tap()
            if keyboard.exists {
                break;
            }
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.5))
        }
        self.typeText(text)
    }
}

