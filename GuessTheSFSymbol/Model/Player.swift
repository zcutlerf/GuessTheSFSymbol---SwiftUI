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
    var correctGuesses: [CorrectGuess] = []
    
    var score: Int {
        correctGuesses.count
    }
}
