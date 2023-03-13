//
//  SingleplayerView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/23/23.
//

import SwiftUI

struct SingleplayerView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var game = SingleplayerGame()
    
    let countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var timeLeft: Int = 60
    
    @State private var guessText = ""
    
    @State private var isShowingSuccessIcon = false
    @State private var isSkipping = false
    
    @State private var isShowingLeaderboardSheet = false
    
    var body: some View {
        
        VStack {
            if !game.isPlayingGame {
                gameOptionsView
            } else if timeLeft == 0 {
                gameoverView
                    .onAppear {
                        game.finishedGame()
                    }
            } else {
                ScrollView {
                    gameplayView
                }
            }
        }
        .padding()
        .overlay(alignment: .bottom) {
            if game.isPlayingGame && !isSkipping {
                AutocompleteView(guessText: $guessText)
            }
        }
        .sheet(isPresented: $isShowingLeaderboardSheet, content: {
            LeaderboardView(difficulty: game.selectedDifficulty, timeLimit: game.timeLimit, highScores: game.highScores)
        })
        .onReceive(countdownTimer) { _ in
            if game.isPlayingGame && timeLeft > 0 {
                timeLeft -= 1
            }
        }
        .onChange(of: game.score) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingSuccessIcon = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingSuccessIcon = false
                }
            }
        }
    }
    
    func skip() {
        isSkipping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guessText = ""
            isSkipping = false
            game.generateNewSymbol()
        }
    }
}

extension SingleplayerView {
    var gameOptionsView: some View {
        VStack(spacing: 25.0) {
            VStack {
                Text("Difficulty:")
                    .font(.title3)
                    .fontWeight(.semibold)
                Picker("Difficulty", selection: $game.selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue.capitalized)
                    }
                }
            }
            
            VStack {
                Text("Time Limit:")
                    .font(.title3)
                    .fontWeight(.semibold)
                Picker("Time Limit", selection: $game.timeLimit) {
                    ForEach(TimeLimit.allCases, id: \.pickerLabel) { timeLimit in
                        Text(timeLimit.pickerLabel)
                            .tag(timeLimit)
                    }
                }
                .onChange(of: game.timeLimit) { newValue in
                    timeLeft = game.timeLimit.seconds
                }
            }
            
            Button {
                game.startGame()
            } label: {
                Text("Play!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            
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
                
                Button {
                    skip()
                } label: {
                    Text("Skip")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
            }
            
            HStack {
                Spacer()
                
                Image(systemName: "clock")
                
                Text(timeLeft.description)
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis.circle")
                
                Text(game.score.description)
                
                Spacer()
            }
            .font(.title.weight(.bold))
            .foregroundColor(.accentColor)
            
            SymbolToGuessView(symbolName: game.symbolToGuess, guessText: $guessText, guessedCorrectly: isSkipping ? false : nil)
                .onChange(of: guessText) { newValue in
                    let isCorrect = game.validateGuess(newValue)
                    
                    if isCorrect {
                        guessText = ""
                    }
                }
                .overlay {
                    if isShowingSuccessIcon {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 40.0))
                            .foregroundColor(.green)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(10.0)
                            .transition(.opacity)
                    }
                }
        }
    }
    
    var gameoverView: some View {
        VStack(spacing: 15.0) {
            Text("Time's Up!")
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
            
            Text("Score: \(game.score)")
                .font(.title3)
                .fontWeight(.bold)
            
            switch game.leaderboardStatus {
            case .notStarted:
                EmptyView()
            case .loading:
                ProgressView()
                
                Text("Loading High Scores...")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.horizontal)
            case .succeeded:
                if let myHighScore = game.myHighScore {
                    Button {
                        isShowingLeaderboardSheet.toggle()
                    } label: {
                        if myHighScore.isNew {
                            Text("NEW High Score")
                                .font(.title3)
                                .fontWeight(.bold)
                        } else {
                            Text("High Score: \(myHighScore.score)")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            case .failed:
                Text("Leaderboard not available.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Symbols guessed correctly:")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(game.correctGuesses, id: \.self) { correctGuess in
                        HStack {
                            Image(systemName: correctGuess)
                            Text(correctGuess)
                        }
                    }
                }
                
                Spacer()
            }
            
            Divider()
            
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

struct SingleplayerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView()
    }
}
