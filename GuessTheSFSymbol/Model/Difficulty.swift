//
//  Difficulty.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/6/23.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case practice
    case easy
    case medium
    case hard
    
    var symbolNames: [String] {
        switch self {
        case .practice:
            return Symbols.shared.practiceSymbolNames
        case .easy:
            return Symbols.shared.easySymbolNames
        case .medium:
            return Symbols.shared.mediumSymbolNames
        case .hard:
            return Symbols.shared.hardSymbolNames
        }
    }
    
    func getLeaderboardID(from timeLimit: TimeLimit) -> String? {
        var id = "solo"
        
        switch timeLimit {
        case .oneMinute:
            id += "60"
        case .twoMinutes:
            id += "120"
        case .threeMinutes:
            id += "180"
        case .fourMinutes:
            id += "240"
        }
        
        switch self {
        case .practice:
            //No leaderboards for practice mode
            return nil
        case .easy:
            id += "easy"
        case .medium:
            id += "medium"
        case .hard:
            id += "hard"
        }
        
        return id
    }
}
