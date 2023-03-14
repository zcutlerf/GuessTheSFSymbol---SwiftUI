//
//  SingleplayerGame+Leaderboardable.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/14/23.
//

import GameKit

protocol Leaderboardable {
    /// If scores have been loaded, this represents the local player's high score, either previous or new.
    var myHighScore: HighScore? { get }
    
    /// The string ID associated with the Game Center leaderboard for the selected difficulty and time limit.
    var leaderboardID: String? { get }
    
    /// Posts a new score to the leaderboard and loads the top scores from the leaderboard.
    func finishedGame()
    
    /// Posts a new score to the Game Center leaderboard for the selected difficulty and time limit.
    func postScoreToLeaderboard()
    
    /// Gets the top 10 scores from the Game Center leaderboard for the selected difficulty and time limit.
    func getHighScoresFromLeaderboard() async throws
    
    /// Checks if the player's current score is a new high score, and replaces it if true.
    func checkForNewHighScore()
    
    /// Re-sorts and re-ranks the high scores so that top scoring players will show first.
    func sortAndRankHighScores()
}

extension SingleplayerGame: Leaderboardable {
    enum LeaderboardStatus {
        case notStarted
        case loading
        case succeeded
        case failed
    }
    
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
    
    internal func postScoreToLeaderboard() {
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
    
    internal func getHighScoresFromLeaderboard() async throws {
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
    
    internal func checkForNewHighScore() {
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
    
    internal func sortAndRankHighScores() {
        //sort, so highest scores are first
        highScores.sort(by: { $0.score > $1.score })
        
        //rank scores
        for index in 0..<highScores.count {
            highScores[index].rank = index + 1
        }
    }
}
