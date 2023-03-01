//
//  Guess.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/21/23.
//

import Foundation

struct CorrectGuess: Codable {
    var date = Date()
    var round: Int
    var answer: String
}
