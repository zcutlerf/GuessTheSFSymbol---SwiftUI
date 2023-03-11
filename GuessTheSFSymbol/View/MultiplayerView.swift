//
//  GameplayView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI

struct MultiplayerView: View {
    @EnvironmentObject var game: MultiplayerGame
    @Environment(\.dismiss) var dismiss
    
    @State private var guessText = ""
    
    @State private var isShowingErrorAlert = false
    @State private var alertMessage = ""
    
    var allPlayers: [Player] {
        var allPlayers = game.opponents
        if let localPlayer = game.localPlayer {
            allPlayers.append(localPlayer)
        }
        
        return allPlayers
    }
    
    var winningPlayer: Player? {
        let sortedPlayers = allPlayers.sorted(by: { $0.score > $1.score })
        
        return sortedPlayers.first
    }
    
    var guessedCorrectly: Bool? {
        guard let localPlayer = game.localPlayer else {
            return nil
        }
        
        // If the player skips, return that they did not guess correctly.
        if localPlayer.guesses.contains(where: { $0.round == game.round && $0.answer == .skip }) {
            return false
        }
        
        if game.roundIsFinished {
            if localPlayer.correctAnswers.contains(where: { $0.round == game.round }) {
                return true
            } else {
                return false
            }
        } else {
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if game.symbolsToGuess == [] {
                    awaitingResponseView
                } else if game.gameIsOver {
                    gameoverView
                } else {
                    gameplayView
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
                if newValue == true && !game.gameIsOver {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //Go to next round
                        game.round += 1
                        game.roundIsFinished = false
                    }
                }
            }
            .onChange(of: game.allPlayersHaveSkipped, perform: { newValue in
                if newValue == true {
                    game.roundIsFinished = true
                }
            })
            .onChange(of: game.hasOpponents, perform: { newValue in
                if newValue == false {
                    alertMessage = "Game Over: All players have quit this game."
                    isShowingErrorAlert = true
                }
            })
            .alert(alertMessage, isPresented: $isShowingErrorAlert) {
                Button("dismiss", role: .cancel) {
                    alertMessage = ""
                    
                    if !game.hasOpponents {
                        game.quitGame()
                    }
                }
            }
            .onAppear {
                game.getSymbolsToGuess()
            }
        }
        .overlay(alignment: .bottom) {
            AutocompleteView(guessText: $guessText)
        }
    }
}

extension MultiplayerView {
    var awaitingResponseView: some View {
        Group {
            avatarsView(showScores: false)
            
            ProgressView()
                .padding()
            
            Text("Waiting for opponents...")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(.horizontal)
            
            Button(role: .destructive) {
                dismiss()
            } label: {
                Text("Quit")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.bordered)
        }
    }
    
    func avatarsView(showScores: Bool) -> some View {
        HStack {
            if game.localPlayer != nil {
                VStack {
                    game.localPlayer!.avatar
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 50.0, maxHeight: 50.0)
                        .clipShape(Circle())
                    
                    if showScores {
                        Text(game.localPlayer!.score.description)
                            .font(.title3)
                            .fontWeight(.bold)
                    } else {
                        Text(game.localPlayer!.gkPlayer.displayName)
                            .lineLimit(1)
                    }
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
                    
                    if showScores {
                        Text(opponent.score.description)
                            .font(.title3)
                            .fontWeight(.bold)
                    } else {
                        Text(opponent.gkPlayer.displayName)
                            .lineLimit(1)
                    }
                }
                .padding(5)
            }
        }
    }
    
    var gameplayView: some View {
        Group {
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
                
                avatarsView(showScores: true)
                
                Spacer()
                
                Button {
                    game.skipRound()
                } label: {
                    Text("Skip")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                
            }
            
            Divider()
            
            if game.symbolsToGuess.indices.contains(game.round) {
                SymbolToGuessView(symbolName: game.symbolsToGuess[game.round], guessText: $guessText, guessedCorrectly: guessedCorrectly)
            }
        }
    }
    
    var gameoverView: some View {
        VStack {
            if let winningPlayer = winningPlayer {
                winningPlayer.avatar
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(.horizontal, 60.0)
                
                Text("\(winningPlayer.gkPlayer.displayName) wins!")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.accentColor)
                
                Text("Score: \(winningPlayer.score.description)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Button(role: .destructive) {
                dismiss()
            } label: {
                Text("Quit")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.bordered)
        }
    }
}

struct MultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerView()
            .environmentObject(Game(withSampleData: true))
    }
}
