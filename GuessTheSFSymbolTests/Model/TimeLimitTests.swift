//
//  TimeLimitTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class TimeLimitTests: XCTestCase {
    func testPickerLabels() {
        let allCases = TimeLimit.allCases
        var pickerLabels: [String] = []
        for timeLimit in allCases {
            pickerLabels.append(timeLimit.pickerLabel)
        }
        
        let expectedPickerLabels = ["1 Minute", "2 Minutes", "3 Minutes", "4 Minutes"]
        
        XCTAssertEqual(pickerLabels, expectedPickerLabels)
    }
    
    func testSecondses() {
        let allCases = TimeLimit.allCases
        var secondses: [Int] = []
        for timeLimit in allCases {
            secondses.append(timeLimit.seconds)
        }
        
        let expectedSecondses = [60, 120, 180, 240]
        
        XCTAssertEqual(secondses, expectedSecondses)
    }
}
