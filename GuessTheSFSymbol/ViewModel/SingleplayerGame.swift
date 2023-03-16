//
//  SingleplayerGame.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/10/23.
//

import GameKit

@MainActor class SingleplayerGame: ObservableObject {
    @Published var isPlayingGame = false
    @Published var selectedDifficulty: Difficulty = .easy
    @Published var timeLimit: TimeLimit = .oneMinute
    
    @Published var symbolToGuess = ""
    @Published var score = 0
    @Published var correctGuesses: [String] = []
    @Published var skippedSymbols: [String] = []
    
    @Published var leaderboardStatus = LeaderboardStatus.notStarted
    @Published var highScores: [HighScore] = []
    
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
            score += numberOfComponents()
            generateNewSymbol()
            
            return true
        }
        
        return false
    }
    
    func numberOfComponents() -> Int {
        let components = symbolToGuess.components(separatedBy: ".")
        return components.count
    }
}
