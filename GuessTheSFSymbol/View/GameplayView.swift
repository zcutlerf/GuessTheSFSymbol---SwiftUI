//
//  GameplayView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI

struct GameplayView: View {
    @EnvironmentObject var game: Game
    
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
                    Image(systemName: game.symbolsToGuess[game.round])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250.0)
                }
                
                Divider()
                
                Text("What is this SF Symbol?")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
                HStack {
                    if game.roundIsFinished {
                        Text(game.symbolsToGuess[game.round])
                            .font(.headline)
                            .padding(7)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    } else {
                        TextField("Guess", text: $guessText)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            .padding()
            .onChange(of: guessText) { newValue in
                game.validateGuess(newValue)
            }
            .onChange(of: game.round) { _ in
                guessText = ""
            }
        }
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView()
            .environmentObject(Game(withSampleData: true))
    }
}
