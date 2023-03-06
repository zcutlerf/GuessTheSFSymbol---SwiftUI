//
//  SingleplayerView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/23/23.
//

import SwiftUI

struct SingleplayerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isPlayingGame = false
    @State private var selectedDifficulty: Difficulty = .easy
    
    let countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var timeLeft: Int = 60
    
    @State private var symbolToGuess = ""
    @State private var guessText = ""
    @State private var score = 0
    @State private var correctGuesses: [String] = []
    
    @State private var isShowingSuccessIcon = false
    @State private var isSkipping = false
    
    var body: some View {
        
        VStack {
            if !isPlayingGame {
                gameOptionsView
            } else if timeLeft == 0 {
                gameoverView
            } else {
                ScrollView {
                    gameplayView
                }
            }
        }
        .padding()
        .onReceive(countdownTimer) { _ in
            if isPlayingGame && timeLeft > 0 {
                timeLeft -= 1
            }
        }
        .onChange(of: score) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingSuccessIcon = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowingSuccessIcon = false
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                AutocompleteView(guess: guessText)
            }
        }
    }
    
    func validateGuess(_ guess: String) {
        let guessCleaned = guess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        let correctAnswerCleaned = symbolToGuess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        
        if guessCleaned == correctAnswerCleaned {
            correctGuesses.append(symbolToGuess)
            guessText = ""
            score += 1
            symbolToGuess = Symbols.shared.randomSymbol(from: selectedDifficulty)
        }
    }
    
    func skip() {
        isSkipping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guessText = ""
            isSkipping = false
            symbolToGuess = Symbols.shared.randomSymbol(from: selectedDifficulty)
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
                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack {
                Text("Time Limit:")
                    .font(.title3)
                    .fontWeight(.semibold)
                Picker("Time Limit", selection: $timeLeft) {
                    Text("15s")
                        .tag(15)
                    Text("30s")
                        .tag(30)
                    Text("60s")
                        .tag(60)
                    Text("120s")
                        .tag(120)
                }
                .pickerStyle(.segmented)
            }
            
            Button {
                symbolToGuess = Symbols.shared.randomSymbol(from: selectedDifficulty)
                isPlayingGame = true
            } label: {
                Text("Play!")
                    .font(.title)
            }
            .buttonStyle(.borderedProminent)
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
                
                Text(score.description)
                
                Spacer()
            }
            .font(.title.weight(.bold))
            .foregroundColor(.accentColor)
            
            SymbolToGuessView(symbolName: symbolToGuess, guessText: $guessText, guessedCorrectly: isSkipping ? false : nil)
                .onChange(of: guessText) { newValue in
                    validateGuess(newValue)
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
            
            Text("Score: \(score)")
                .font(.title3)
                .fontWeight(.bold)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Symbols guessed correctly:")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(correctGuesses, id: \.self) { correctGuess in
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
