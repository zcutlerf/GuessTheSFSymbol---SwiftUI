//
//  SingleplayerView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/23/23.
//

import SwiftUI

struct SingleplayerView: View {
    let countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var timeLeft: Int = 60
    
    @State private var symbolToGuess = Symbols.shared.randomSymbol()
    @State private var guessText = ""
    @State private var score = 0
    
    @State private var isShowingSuccessIcon = false
    
    var body: some View {
        ScrollView {
            VStack {
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
                
                SymbolToGuessView(symbolName: symbolToGuess, guessText: $guessText, guessedCorrectly: false)
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
            .padding()
            .onReceive(countdownTimer) { _ in
                timeLeft -= 1
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
        }
    }
    
    func validateGuess(_ guess: String) {
        let guessCleaned = guess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        let correctAnswerCleaned = symbolToGuess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        
        if guessCleaned == correctAnswerCleaned {
            guessText = ""
            score += 1
            symbolToGuess = Symbols.shared.randomSymbol()
        }
    }
}

struct SingleplayerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView()
    }
}
