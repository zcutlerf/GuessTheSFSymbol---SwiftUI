//
//  TimeLimit.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/10/23.
//

import Foundation

enum TimeLimit: String, CaseIterable, Codable {
    case oneMinute
    case twoMinutes
    case threeMinutes
    case fourMinutes
    
    var pickerLabel: String {
        switch self {
        case .oneMinute:
            return "1 Minute"
        case .twoMinutes:
            return "2 Minutes"
        case .threeMinutes:
            return "3 Minutes"
        case .fourMinutes:
            return "4 Minutes"
        }
    }
    
    var seconds: Int {
        switch self {
        case .oneMinute:
            return 60
        case .twoMinutes:
            return 120
        case .threeMinutes:
            return 180
        case .fourMinutes:
            return 240
        }
    }
}
