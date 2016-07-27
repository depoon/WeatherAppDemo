//
//  WaitSteps.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation
import XCTest
import XCTest_Gherkin

class WaitSteps : StepDefiner {  
    override func defineSteps() {
        
        step("I wait to see \"(.*?)\""){ (matches: [String]) in
            self.test.expectationForPredicate(
                NSPredicate(format: "exists == 1"), 
                evaluatedWithObject: XCUIApplication().staticTexts[matches.first!], 
                handler: nil
            )
            self.test.waitForExpectationsWithTimeout(5, handler: nil)
        }
            
    }
}

