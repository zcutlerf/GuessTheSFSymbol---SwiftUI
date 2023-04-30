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
    
    func testEasySymbolsNotEmpty() {
        let easySymbols = Symbols.shared.easySymbolNames
        let easySymbolsCount = easySymbols.count
        
        XCTAssertNotEqual(easySymbolsCount, 0)
    }
    
    func testMediumSymbolsNotEmpty() {
        let mediumSymbols = Symbols.shared.mediumSymbolNames
        let mediumSymbolsCount = mediumSymbols.count
        
        XCTAssertNotEqual(mediumSymbolsCount, 0)
    }
    
    func testHardSymbolsNotEmpty() {
        let hardSymbols = Symbols.shared.hardSymbolNames
        let hardSymbolsCount = hardSymbols.count
        
        XCTAssertNotEqual(hardSymbolsCount, 0)
    }
    
    func testMultiplayerSymbolsNotEmpty() {
        let multiplayerSymbols = Symbols.shared.multiplayerSymbolNames
        let multiplayerSymbolsCount = multiplayerSymbols.count
        
        XCTAssertNotEqual(multiplayerSymbolsCount, 0)
    }
    
    func testMediumSymbolsContainedWithinMultiplayerSymbols() {
        let hardSymbols = Symbols.shared.multiplayerSymbolNames
        let mediumSymbols = Symbols.shared.mediumSymbolNames
        
        for symbol in mediumSymbols {
            if !hardSymbols.contains(symbol) {
                XCTFail("Multiplayer symbols does not have \(symbol), but medium symbols does.")
            }
        }
    }
    
    func testEasySymbolsContainedWithinMultiplayerSymbols() {
        let multiplayerSymbols = Symbols.shared.multiplayerSymbolNames
        let easySymbols = Symbols.shared.easySymbolNames
        
        for symbol in easySymbols {
            if !multiplayerSymbols.contains(symbol) {
                XCTFail("Multiplayer symbols does not have \(symbol), but easy symbols does.")
            }
        }
    }
    
    func testHardSymbolsContainedWithinMultiplayerSymbols() {
        let multiplayerSymbols = Symbols.shared.multiplayerSymbolNames
        let hardSymbols = Symbols.shared.hardSymbolNames
        
        for symbol in hardSymbols {
            if !multiplayerSymbols.contains(symbol) {
                XCTFail("Multiplayer symbols does not have \(symbol), but hard symbols does.")
            }
        }
    }
    
    func testGenerateRoundSymbols() {
        let roundSymbols = Symbols.shared.generateMultiplayerRoundSymbols(for: 5)
        
        XCTAssertEqual(roundSymbols.count, 5)
    }
}
