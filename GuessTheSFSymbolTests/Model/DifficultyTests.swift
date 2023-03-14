//
//  DifficultyTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class DifficultyTests: XCTestCase {
    func testCaseIteratableInOrder() {
        let allCases = Difficulty.allCases
        let expectedCases: [Difficulty] = [.practice, .easy, .medium, .hard]
        
        XCTAssertEqual(allCases, expectedCases)
    }
    
    func testEasySymbolsEqual() {
        let easySymbolsFromDifficulty = Difficulty.easy.symbolNames
        let easySymbolsFromSingleton = Symbols.shared.easySymbolNames
        
        XCTAssertEqual(easySymbolsFromDifficulty, easySymbolsFromSingleton)
    }
    
    func testNoPracticeLeaderboard() {
        let leaderboardID = Difficulty.practice.getLeaderboardID(from: .oneMinute)
        
        XCTAssertNil(leaderboardID)
    }
    
    func test1MinuteEasyLeaderboardID() {
        let leaderboardID = Difficulty.easy.getLeaderboardID(from: .oneMinute)
        let expectedLeaderboardID = "solo60easy"
        
        XCTAssertEqual(leaderboardID, expectedLeaderboardID)
    }
    
    func test2MinutesEasyLeaderboardID() {
        let leaderboardID = Difficulty.easy.getLeaderboardID(from: .twoMinutes)
        let expectedLeaderboardID = "solo120easy"
        
        XCTAssertEqual(leaderboardID, expectedLeaderboardID)
    }
    
    func test3MinutesMediumLeaderboardID() {
        let leaderboardID = Difficulty.medium.getLeaderboardID(from: .threeMinutes)
        let expectedLeaderboardID = "solo180medium"
        
        XCTAssertEqual(leaderboardID, expectedLeaderboardID)
    }
    
    func test4MinutesHardLeaderboardID() {
        let leaderboardID = Difficulty.hard.getLeaderboardID(from: .fourMinutes)
        let expectedLeaderboardID = "solo240hard"
        
        XCTAssertEqual(leaderboardID, expectedLeaderboardID)
    }
}
