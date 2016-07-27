//
//  WeatherAppUITest.swift
//  WeatherAppUITest
//
//  Created by Kenneth Poon on 9/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import XCTest
import XCTest_Gherkin


class WeatherAppUITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUserAbleToSearchForValidCity() {
        Given("I am at Weather Search Form Page")
        When ("I enter city search for \"London\"")
        
        Then ("I should be at Weather Details Page")
        And  ("I wait to see \"London\"")
       // And  ("I wait to see \"77\"")
    }
    
    func testUserSeesErrorMessageForInvalidCity() {

        Given("I am at Weather Search Form Page")
        When ("I enter city search for \"NotACity\"")        
        
        Then ("I wait to see \"Error\"")
        And  ("I wait to see \"Unable to find any matching weather location to the query submitted!\"")
        And  ("I tap on alert button \"OK\"")
  
    }
}   
