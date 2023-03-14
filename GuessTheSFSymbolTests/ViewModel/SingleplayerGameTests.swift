//
//  SingleplayerGameTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class SingleplayerGameTests: XCTestCase {
    var game: SingleplayerGame!
    
    override func setUp() {
        super.setUp()
        game = SingleplayerGame()
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
    
    func testStartGame() {
        game.startGame()
        
        XCTAssertEqual(game.isPlayingGame, true)
    }
    
    func testGenerateNewSymbol() {
        game.generateNewSymbol()
        
        XCTAssertNotEqual(game.symbolToGuess, "")
    }
    
    func testLeaderboardID() {
        XCTAssertEqual(game.leaderboardID, "solo60easy")
    }
    
    func testValidateExactGuess() {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circle.fill"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    func testValidateCapitalizedGuess() {
        game.symbolToGuess = "circle.fill"
        
        let guess = "CIRCLE.FILL"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    func testValidatePunctuatedGuess() {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circle.!!fill:)"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    func testValidateNonPunctuatedGuess() {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circlefill"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    func testIncorrectGuess() {
        game.symbolToGuess = "circle.fill"
        
        let guess = "incorrect.guess"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertFalse(isCorrect)
    }
    
    func testSortAndRankHighScores() {
        game.highScores = [
            HighScore(displayName: "Worst Player", rank: 4, score: 1, isNew: false),
            HighScore(displayName: "Best Player", rank: 5, score: 10, isNew: false),
            HighScore(displayName: "Medium Player", rank: 2, score: 5, isNew: false)
        ]
        
        game.sortAndRankHighScores()
        
        if game.highScores[0].rank != 1 {
            XCTFail()
        }
        
        if game.highScores[1].rank != 2 {
            XCTFail()
        }
        
        if game.highScores[2].rank != 3 {
            XCTFail()
        }
        
        if game.highScores[0].displayName != "Best Player" {
            XCTFail()
        }
    }
}
