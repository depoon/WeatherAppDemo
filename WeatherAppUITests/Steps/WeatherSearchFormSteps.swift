//
//  WeatherSearchFormSteps.swift
//  WeatherApp
//
//  Created by Kenneth Poon on 11/7/16.
//  Copyright © 2016 Soheil. All rights reserved.
//

import Foundation
import XCTest_Gherkin

class WeatherSearchFormSteps : StepDefiner {  
    override func defineSteps() {
        
        step("I enter city search for \"(.*?)\""){ (matches: [String]) in
            let weatherSearchPage = WeatherSearchPage(testCase: self.test)
            weatherSearchPage.userSearchForCity(matches.first!)
        }
    }
}
