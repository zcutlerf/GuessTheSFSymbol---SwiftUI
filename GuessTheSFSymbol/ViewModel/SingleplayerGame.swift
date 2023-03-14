//
//  SingleplayerGame.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/10/23.
//

import GameKit

class SingleplayerGame: ObservableObject {
    @Published var isPlayingGame = false
    @Published var selectedDifficulty: Difficulty = .easy
    @Published var timeLimit: TimeLimit = .oneMinute
    
    @Published var symbolToGuess = ""
    @Published var score = 0
    @Published var correctGuesses: [String] = []
    
    enum LeaderboardStatus {
        case notStarted
        case loading
        case succeeded
        case failed
    }
    @Published var leaderboardStatus = LeaderboardStatus.notStarted
    @Published var highScores: [HighScore] = []
    
    var myHighScore: HighScore? {
        if let myScore = highScores.first(where: { $0.displayName == GKLocalPlayer.local.displayName }) {
            return myScore
        } else {
            return nil
        }
    }
    
    var leaderboardID: String? {
        selectedDifficulty.getLeaderboardID(from: timeLimit)
    }
    
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
    
    func finishedGame() {
        leaderboardStatus = .loading
        
        postScoreToLeaderboard()
        
        Task {
            do {
                try await getHighScoresFromLeaderboard()
                
                checkForNewHighScore()
                
                leaderboardStatus = .succeeded
            } catch {
                print("Error fetching leaderboard data: \(error.localizedDescription)")
                leaderboardStatus = .failed
            }
        }
    }
    
    func postScoreToLeaderboard() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        guard let leaderboardID = leaderboardID else {
            return
        }
        
        if score == 0 {
            return
        }
        
        Task {
            do {
                try await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID])
            } catch {
                print("Error sending new score to leaderboard: \(error.localizedDescription)")
            }
        }
    }
    
    func getHighScoresFromLeaderboard() async throws {
        guard let leaderboardID = leaderboardID else {
            return
        }
        
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
        
        guard let leaderboard = leaderboards.first else {
            return
        }
        
        let entries = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...10))
        
        for scoreEntry in entries.1 {
            let newHighScore = HighScore(displayName: scoreEntry.player.displayName, rank: scoreEntry.rank, score: scoreEntry.score, isNew: false)
            highScores.append(newHighScore)
        }
        
        sortAndRankHighScores()
        
        leaderboardStatus = .succeeded
    }
    
    func checkForNewHighScore() {
        if let myHighScore = myHighScore {
            if score > myHighScore.score {
                if let indexOfMyScore = highScores.firstIndex(where: { $0.displayName == myHighScore.displayName}) {
                    
                    highScores[indexOfMyScore] = HighScore(displayName: GKLocalPlayer.local.displayName, rank: 0, score: score, isNew: true)
                }
            }
        } else {
            let myFirstScore = HighScore(displayName: GKLocalPlayer.local.displayName, rank: 0, score: score, isNew: true)
            highScores.append(myFirstScore)
        }
        
        sortAndRankHighScores()
    }
    
    func sortAndRankHighScores() {
        //sort, so highest scores are first
        highScores.sort(by: { $0.score > $1.score })
        
        //rank scores
        for index in 0..<highScores.count {
            highScores[index].rank = index + 1
        }
    }
}
