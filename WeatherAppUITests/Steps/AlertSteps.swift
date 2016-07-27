//
//  AlertSteps.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation
import XCTest
import XCTest_Gherkin

class AlertSteps : StepDefiner {  
    override func defineSteps() {
        
        step("I tap on alert button \"(.*?)\""){ (matches: [String]) in
            XCUIApplication().buttons[matches.first!].tap()
        }
        
    }
}
