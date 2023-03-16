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
            if !game.gameIsOver {
                AutocompleteView(guessText: $guessText)
            }
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
                        .overlay {
                            playerRoundStateOverlay(for: game.localPlayer!)
                        }
                    
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
                        .overlay {
                            playerRoundStateOverlay(for: opponent)
                        }
                    
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
    
    func playerRoundStateOverlay(for player: Player) -> some View {
        Group {
            switch player.roundState(for: game.round) {
            case .notGuessed:
                EmptyView()
            case .skipped:
                Image(systemName: "arrowshape.zigzag.forward")
                    .font(.system(size: 30.0))
                    .foregroundColor(.red)
                    .padding(7)
                    .background(.regularMaterial)
                    .clipShape(Circle())
            case .correct:
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 30.0))
                    .foregroundColor(.green)
                    .padding(3)
                    .background(.regularMaterial)
                    .clipShape(Circle())
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
            
            ProgressView(value: Double(game.round) / Double(game.numberOfRounds))
                .progressViewStyle(.linear)
            
            if game.symbolsToGuess.indices.contains(game.round) {
                SymbolToGuessView(symbolName: game.symbolsToGuess[game.round], guessText: $guessText, guessedCorrectly: game.guessedCorrectly)
            }
        }
    }
    
    var gameoverView: some View {
        VStack {
            if game.winningPlayers.count == 1 {
                game.winningPlayers[0].avatar
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(.horizontal, 60.0)
                
                Text("\(game.winningPlayers[0].gkPlayer.displayName) wins!")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.accentColor)
                
                Text("Score: \(game.winningPlayers[0].score.description)")
                    .font(.title3)
                    .fontWeight(.bold)
            } else if game.winningPlayers.count > 1 {
                Text("It's a tie!")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.accentColor)
                
                Text("Score: \(game.winningPlayers[0].score.description)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    ForEach(game.winningPlayers) { player in
                        VStack {
                            player.avatar
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                            
                            Text(player.gkPlayer.displayName)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                }
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
            .environmentObject(MultiplayerGame(withSampleData: true))
    }
}
