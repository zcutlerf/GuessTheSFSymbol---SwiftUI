//
//  MultiplayerGameTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class MultiplayerGameTests: XCTestCase {
    var game: MultiplayerGame!
    
    override func setUp() async throws {
        game = await MultiplayerGame(withSampleData: true)
    }
    
    override func tearDown() async throws {
        game = nil
    }
    
    func testHasOpponent() async throws {
        let opponentsCount = await game.opponents.count
        
        XCTAssertEqual(opponentsCount, 1)
        
        let hasOpponents = await game.hasOpponents
        
        XCTAssertTrue(hasOpponents)
    }
    
    func testResetGame() async throws {
        await game.resetGame()
        
        let hasOpponents = await game.hasOpponents
        
        XCTAssertFalse(hasOpponents)
    }
    
    func testValidateExactGuess() async throws {
        let answer = await game.symbolsToGuess[0]
        let guess = answer
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 1)
    }
    
    func testValidateCapitalizedGuess() async throws {
        let answer = await game.symbolsToGuess[0]
        let guess = answer.uppercased()
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 1)
    }
    
    func testValidatePunctuatedGuess() async throws {
        let answer = await game.symbolsToGuess[0]
        let guess = answer.appending("...!:)")
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 1)
    }
    
    func testValidateNonPunctuatedGuess() async throws {
        let answer = await game.symbolsToGuess[0]
        var guess = answer
        guess.removeAll(where: { $0.isPunctuation })
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 1)
    }
    
    func testIncorrectGuess() async throws {
        let guess = "incorrect.symbol"
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 0)
    }
    
    func testValidateMultipleCorrectGuesses() async throws {
        let answer = await game.symbolsToGuess[0]
        let guess = answer
        await game.validateGuess(guess)
        await game.validateGuess(guess)
        await game.validateGuess(guess)
        let score = await game.localPlayer?.score
        
        XCTAssertEqual(score, 1)
    }
    
    func testLocalPlayerGuessedCorrectly() async throws {
        let answer = await game.symbolsToGuess[0]
        let guess = answer
        await game.validateGuess(guess)
        let guessedCorrectly = await game.playerGuessedCorrectly(game.localPlayer!.id)
        
        XCTAssertTrue(guessedCorrectly)
    }
    
    func testSkipRound() async throws {
        await game.skipRound()
        
        let localPlayerGuesses = await game.localPlayer!.guesses
        
        if !localPlayerGuesses.contains(where: { $0.answer == .skip }) {
            XCTFail()
        }
        
        let haveAllPlayersSkipped = await game.allPlayersHaveSkipped
        
        XCTAssertFalse(haveAllPlayersSkipped)
    }
    
    @MainActor func testAllPlayersHaveSkippedTrue() async throws {
        game.skipRound()
        
        let opponentSkip = Guess(round: 0, answer: .skip)
        
        game.opponents[0].guesses.append(opponentSkip)
        
        let haveAllPlayersSkipped = game.allPlayersHaveSkipped
        
        XCTAssertTrue(haveAllPlayersSkipped)
    }
}
