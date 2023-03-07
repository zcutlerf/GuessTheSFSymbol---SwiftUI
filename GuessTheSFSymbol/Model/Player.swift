//
//  Player.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import GameKit
import SwiftUI

struct Player: Identifiable {
    var id = UUID()
    var gkPlayer: GKPlayer
    var avatar = Image(systemName: "person.circle")
    var guesses: [Guess] = []
    
    var correctAnswers: [Guess] {
        guesses.filter({
            switch $0.answer {
            case .correct(_):
                return true
            case .skip:
                return false
            }
        })
    }
    
    var score: Int {
        correctAnswers.count
    }
}
