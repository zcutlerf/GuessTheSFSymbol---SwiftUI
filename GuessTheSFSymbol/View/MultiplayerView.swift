//
//  GameplayView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI

struct MultiplayerView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) var dismiss
    
    @State private var guessText = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    if game.localPlayer != nil {
                        VStack {
                            game.localPlayer!.avatar
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 50.0, maxHeight: 50.0)
                                .clipShape(Circle())
                            
                            Text(game.localPlayer!.score.description)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(5)
                    }
                    
                    ForEach(game.opponents) { opponent in
                        VStack {
                            opponent.avatar
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 50.0, maxHeight: 50.0)
                                .clipShape(Circle())
                            
                            Text(opponent.score.description)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(5)
                    }
                }
                
                HStack {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Quit")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button {
                        //TODO: send skip message of some sort? Maybe CorrectGuess could become Submission, more general
                    } label: {
                        Text("Skip")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                    
                }
                
                Divider()
                
                if game.symbolsToGuess.indices.contains(game.round) {
                    SymbolToGuessView(symbolName: game.symbolsToGuess[game.round], guessText: $guessText, guessedCorrectly: game.roundIsFinished)
                }
            }
            .padding()
            .onChange(of: guessText) { newValue in
                game.validateGuess(newValue)
            }
            .onChange(of: game.round) { _ in
                guessText = ""
            }
            .onChange(of: game.roundIsFinished) { newValue in
                if newValue == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        //Go to next round
                        game.round += 1
                        game.roundIsFinished = false
                    }
                }
            }
        }
    }
}

struct MultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerView()
            .environmentObject(Game(withSampleData: true))
    }
}
