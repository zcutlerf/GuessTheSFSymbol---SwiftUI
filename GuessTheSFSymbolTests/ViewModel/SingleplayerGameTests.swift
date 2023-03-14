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
    
    override func setUp() async throws {
        game = await SingleplayerGame()
    }
    
    override func tearDown() async throws {
        game = nil
    }
    
    func testStartGame() async throws {
        await game.startGame()
        
        let isPlayingGame = await game.isPlayingGame
        
        XCTAssertEqual(isPlayingGame, true)
    }
    
    func testGenerateNewSymbol() async throws {
        await game.generateNewSymbol()
        let symbolToGuess = await game.symbolToGuess
        
        XCTAssertNotEqual(symbolToGuess, "")
    }
    
    func testLeaderboardID() async throws {
        let leaderboardID = await game.leaderboardID
        XCTAssertEqual(leaderboardID, "solo60easy")
    }
    
    @MainActor func testValidateExactGuess() async throws {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circle.fill"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    @MainActor func testValidateCapitalizedGuess() async throws {
        game.symbolToGuess = "circle.fill"
        
        let guess = "CIRCLE.FILL"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    @MainActor func testValidatePunctuatedGuess() async throws {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circle.!!fill:)"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    @MainActor func testValidateNonPunctuatedGuess() async throws {
        game.symbolToGuess = "circle.fill"
        
        let guess = "circlefill"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertTrue(isCorrect)
    }
    
    @MainActor func testIncorrectGuess() async throws {
        game.symbolToGuess = "circle.fill"
        
        let guess = "incorrect.guess"
        let isCorrect = game.validateGuess(guess)
        
        XCTAssertFalse(isCorrect)
    }
    
    @MainActor func testSortAndRankHighScores() async throws {
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
