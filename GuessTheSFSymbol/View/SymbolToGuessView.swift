//
//  SymbolToGuessView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/23/23.
//

import SwiftUI

struct SymbolToGuessView: View {
    var symbolName: String
    @Binding var guessText: String
    var guessedCorrectly: Bool
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .frame(height: 180.0)
            
            
            Divider()
            
            Text("What is this SF Symbol?")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            HStack {
                if guessedCorrectly {
                    Text(symbolName)
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
    }
}

struct SymbolToGuessView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolToGuessView(symbolName: "tortoise", guessText: .constant("turtle"), guessedCorrectly: false)
    }
}
