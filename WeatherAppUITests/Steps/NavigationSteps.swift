//
//  NavigationSteps.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation


import XCTest_Gherkin

class NavigationSteps : StepDefiner {  
    override func defineSteps() {
        
        step("I (am|should be) at Weather Search Form Page"){
            WeatherSearchPage(testCase:self.test)
        }
        
        step("I (am|should be) at Weather Details Page"){
            WeatherDetailsPage(testCase:self.test)
        }
    }
}