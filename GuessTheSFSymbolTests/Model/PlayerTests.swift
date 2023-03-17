//
//  PlayerTests.swift
//  GuessTheSFSymbolTests
//
//  Created by Zoe Cutler on 3/14/23.
//

import XCTest
import Foundation
import GameKit
import SwiftUI
@testable import GuessTheSFSymbol

final class PlayerTests: XCTestCase {
    func testPlayerHasZeroCorrectGuesses() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [])
        
        let actualCorrectAnswers = player.score
        let expectedCorrectAnswers = 0
        
        XCTAssertEqual(actualCorrectAnswers, expectedCorrectAnswers)
    }

    func testPlayerHasTwoPoints() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill"))
        ])
        
        let actualScore = player.score
        let expectedScore = 2
        
        XCTAssertEqual(actualScore, expectedScore)
    }
    
    func testPlayerHasThreePoints() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle")),
            Guess(round: 1, answer: .correct("square.fill"))
        ])
        
        let actualScore = player.score
        let expectedScore = 3
        
        XCTAssertEqual(actualScore, expectedScore)
    }
    
    func testPlayerHasFourPoints() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill")),
            Guess(round: 1, answer: .correct("square.fill"))
        ])
        
        let actualScore = player.score
        let expectedScore = 4
        
        XCTAssertEqual(actualScore, expectedScore)
    }
    
    func testPlayerHasTwoPointsAndSkipsAreNotCounted() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill")),
            Guess(round: 1, answer: .skip),
            Guess(round: 2, answer: .skip)
        ])
        
        let actualScore = player.score
        let expectedScore = 2
        
        XCTAssertEqual(actualScore, expectedScore)
    }
}
