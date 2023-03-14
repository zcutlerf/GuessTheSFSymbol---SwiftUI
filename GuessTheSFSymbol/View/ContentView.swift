//
//  ContentView.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI
import GameKit

struct ContentView: View {
    @EnvironmentObject var game: MultiplayerGame
    @State private var isPlayingSolo: Bool = false
    
    @State private var symbolPreview: String = "tortoise"
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    @State private var isShowingHowToPlay = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25.0) {
                HStack(spacing: 20.0) {
                    Image(systemName: "questionmark")
                        .font(.title.weight(.bold))
                        .foregroundColor(.accentColor)
                    
                    Image(systemName: symbolPreview)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180.0, height: 100.0)
                    
                    Image(systemName: "questionmark")
                        .font(.title.weight(.bold))
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                Button {
                    isShowingHowToPlay.toggle()
                } label: {
                    Text("How to Play")
                        .font(.title)
                }
                .buttonStyle(.bordered)
                
                Button {
                    isPlayingSolo.toggle()
                } label: {
                    Text("Single Player")
                        .font(.title)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    game.startGame()
                } label: {
                    Text("Multi Player")
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
            .sheet(isPresented: $isShowingHowToPlay, content: {
                HowToPlayView()
            })
            .fullScreenCover(isPresented: $isPlayingSolo) {
                SingleplayerView()
            }
            .fullScreenCover(isPresented: $game.isPlayingGame) {
                MultiplayerView()
                    .onDisappear {
                        game.quitGame()
                    }
            }
            .onReceive(timer, perform: { _ in
                symbolPreview = Symbols.shared.randomSymbol(from: .hard)
            })
            .navigationTitle("SFGuess")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MultiplayerGame(withSampleData: true))
    }
}
