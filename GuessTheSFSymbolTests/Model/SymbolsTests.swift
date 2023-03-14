//
//  SymbolsTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class SymbolsTests: XCTestCase {
    func testPracticeSymbolsNotEmpty() {
        let practiceSymbols = Symbols.shared.practiceSymbolNames
        let practiceSymbolsCount = practiceSymbols.count
        
        XCTAssertNotEqual(practiceSymbolsCount, 0)
    }
    
    func testHardSymbolsNotEmpty() {
        let hardSymbols = Symbols.shared.hardSymbolNames
        let hardSymbolsCount = hardSymbols.count
        
        XCTAssertNotEqual(hardSymbolsCount, 0)
    }
    
    func testMediumSymbolsContainedWithinHardSymbols() {
        let hardSymbols = Symbols.shared.hardSymbolNames
        let mediumSymbols = Symbols.shared.mediumSymbolNames
        
        for symbol in mediumSymbols {
            if !hardSymbols.contains(symbol) {
                XCTFail("Hard symbols does not have \(symbol), but medium symbols does.")
            }
        }
    }
    
    func testMoreHardSymbolsThanMediumSymbols() {
        let hardSymbols = Symbols.shared.hardSymbolNames
        let mediumSymbols = Symbols.shared.mediumSymbolNames
        
        XCTAssertGreaterThan(hardSymbols.count, mediumSymbols.count)
    }
    
    func testEasySymbolsContainedWithinHardSymbols() {
        let hardSymbols = Symbols.shared.hardSymbolNames
        let easySymbols = Symbols.shared.easySymbolNames
        
        for symbol in easySymbols {
            if !hardSymbols.contains(symbol) {
                XCTFail("Hard symbols does not have \(symbol), but easy symbols does.")
            }
        }
    }
    
    func testMoreMediumSymbolsThanEasySymbols() {
        let mediumSymbols = Symbols.shared.mediumSymbolNames
        let easySymbols = Symbols.shared.easySymbolNames
        
        XCTAssertGreaterThan(mediumSymbols.count, easySymbols.count)
    }
}
