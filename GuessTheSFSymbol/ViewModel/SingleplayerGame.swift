//
//  SingleplayerGame.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/10/23.
//

import Foundation

class SingleplayerGame: ObservableObject {
    @Published var isPlayingGame = false
    @Published var selectedDifficulty: Difficulty = .easy
    
    @Published var symbolToGuess = ""
    @Published var score = 0
    @Published var correctGuesses: [String] = []
    
    func startGame() {
        generateNewSymbol()
        isPlayingGame = true
    }
    
    func generateNewSymbol() {
        symbolToGuess = Symbols.shared.randomSymbol(from: selectedDifficulty)
    }
    
    func validateGuess(_ guess: String) -> Bool {
        let guessCleaned = guess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        let correctAnswerCleaned = symbolToGuess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        
        if guessCleaned == correctAnswerCleaned {
            correctGuesses.append(symbolToGuess)
            score += 1
            generateNewSymbol()
            
            return true
        }
        
        return false
    }
}
