//
//  ContentView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI
import GameKit

struct ContentView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        VStack {
            Button {
                game.startGame()
            } label: {
                Text("Start Game")
                    .font(.title)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!game.isAuthenticated)
        }
        .padding()
        .onAppear {
            if !GKLocalPlayer.local.isAuthenticated {
                game.authenticateLocalPlayer()
            }
        }
        .fullScreenCover(isPresented: $game.isPlayingGame) {
            GameplayView()
                .onDisappear {
                    game.quitGame()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game(withSampleData: true))
    }
}
