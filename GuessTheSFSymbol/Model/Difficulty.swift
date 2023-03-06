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
}
