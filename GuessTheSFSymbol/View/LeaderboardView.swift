//
//  LeaderboardView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/11/23.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.dismiss) var dismiss
    
    var difficulty: Difficulty
    var timeLimit: TimeLimit
    var highScores: [HighScore]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .padding(10)
                        .contentShape(Rectangle())
                }
            }
            
            Text("Best \(timeLimit.pickerLabel) on \(difficulty.rawValue.capitalized)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.green)
                .padding(.horizontal)
            
            List {
                ForEach(highScores, id: \.rank) { highScore in
                    HStack {
                        Image(systemName: "\(highScore.rank).circle")
                            .foregroundColor(.green)
                            .font(.title2.weight(.semibold))
                        
                        if highScore.isNew {
                            Text("NEW: \(highScore.displayName)")
                                .fontWeight(.bold)
                        } else {
                            Text(highScore.displayName)
                        }
                        
                        Spacer()
                        
                        Text(highScore.score.description)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(difficulty: .easy, timeLimit: .oneMinute, highScores: [HighScore(displayName: "Zoe", rank: 1, score: 12, isNew: true), HighScore(displayName: "Cory", rank: 2, score: 8, isNew: false)])
    }
}
