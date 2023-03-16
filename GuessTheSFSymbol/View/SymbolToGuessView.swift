//
//  SymbolToGuessView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/23/23.
//

import SwiftUI

struct SymbolToGuessView: View {
    @FocusState private var textFieldIsFocused: Bool
    
    var symbolName: String
    @Binding var guessText: String
    var guessedCorrectly: Bool?
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .frame(height: 160.0)
            
            
            Divider()
            
            HStack {
                if guessedCorrectly == nil {
                    TextField("Guess.the.SF.Symbol", text: $guessText)
                        .textFieldStyle(.roundedBorder)
                        .focused($textFieldIsFocused)
                } else {
                    Text(symbolName)
                        .font(.headline)
                        .padding(7)
                    
                    Spacer()
                    
                    if guessedCorrectly! {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    } else {
                        Image(systemName: "arrowshape.zigzag.forward")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                }
            }
        }
        .onAppear {
            textFieldIsFocused = true
        }
    }
}

struct SymbolToGuessView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolToGuessView(symbolName: "tortoise", guessText: .constant("turtle"), guessedCorrectly: false)
    }
}
