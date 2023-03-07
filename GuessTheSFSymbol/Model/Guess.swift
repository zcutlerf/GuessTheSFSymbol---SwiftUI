//
//  Guess.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/21/23.
//

import Foundation

struct Guess: Codable {
    var date = Date()
    var round: Int
    var answer: Answer
    
    enum Answer: Codable, Equatable {
        case correct(String)
        case skip
    }
}
