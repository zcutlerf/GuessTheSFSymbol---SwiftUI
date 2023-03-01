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
    var guessedCorrectly: Bool?
    
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
                if guessedCorrectly == nil {
                    TextField("Guess", text: $guessText)
                        .textFieldStyle(.roundedBorder)
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
                        Image(systemName: "xmark.seal")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
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
