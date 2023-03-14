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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPlayerHasZeroCorrectGuesses() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [])
        
        let actualCorrectAnswers = player.score
        let expectedCorrectAnswers = 0
        
        XCTAssertEqual(actualCorrectAnswers, expectedCorrectAnswers)
    }

    func testPlayerHasOneCorrectGuess() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill"))
        ])
        
        let actualCorrectAnswers = player.score
        let expectedCorrectAnswers = 1
        
        XCTAssertEqual(actualCorrectAnswers, expectedCorrectAnswers)
    }
    
    func testPlayerHasTwoCorrectGuesses() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill")),
            Guess(round: 1, answer: .correct("square.fill"))
        ])
        
        let actualCorrectAnswers = player.score
        let expectedCorrectAnswers = 2
        
        XCTAssertEqual(actualCorrectAnswers, expectedCorrectAnswers)
    }
    
    func testPlayerHasOneCorrectGuessAndSkipsAreNotCounted() {
        let player = Player(gkPlayer: GKPlayer(), guesses: [
            Guess(round: 0, answer: .correct("circle.fill")),
            Guess(round: 1, answer: .skip),
            Guess(round: 2, answer: .skip)
        ])
        
        let actualCorrectAnswers = player.score
        let expectedCorrectAnswers = 1
        
        XCTAssertEqual(actualCorrectAnswers, expectedCorrectAnswers)
    }
}
