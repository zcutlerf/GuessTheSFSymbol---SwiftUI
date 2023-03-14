//
//  LeaderboardService.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/14/23.
//

import GameKit

actor LeaderboardService {
    static func loadLeaderboards(IDs leaderboardIDs: [String]?) async throws -> [GKLeaderboard] {
        try await GKLeaderboard.loadLeaderboards(IDs: leaderboardIDs)
    }
    
    static func loadEntries(in leaderboard: GKLeaderboard, for playerScope: GKLeaderboard.PlayerScope, timeScope: GKLeaderboard.TimeScope, range: NSRange) async throws -> (GKLeaderboard.Entry?, [GKLeaderboard.Entry], Int) {
        try await leaderboard.loadEntries(for: playerScope, timeScope: timeScope, range: range)
    }
    
    static func submitScore(_ score: Int, context: Int, player: GKPlayer, leaderboardIDs: [String]) async throws {
        try await GKLeaderboard.submitScore(score, context: context, player: player, leaderboardIDs: leaderboardIDs)
    }
}
