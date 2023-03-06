//
//  AutocompleteView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/6/23.
//

import SwiftUI

struct AutocompleteView: View {
    var guess: String
    
    var latestComponent: String {
        if guess.contains(".") {
            let lastPeriodIndex = guess.lastIndex(of: ".")!
            if guess.last == "." {
                return ""
            }
            return String(guess.suffix(from: lastPeriodIndex))
        } else {
            return guess
        }
    }
    
    var suggestedComponents: [String] {
        if latestComponent == "" {
            return []
        } else {
            let filteredComponents = Symbols.shared.components.filter({ $0.hasPrefix(latestComponent) })
            let endIndex = min(filteredComponents.endIndex, 5)
            return Array<String>(filteredComponents[0..<endIndex])
        }
    }
    
    var body: some View {
        ScrollView([.horizontal]) {
            HStack {
                ForEach(suggestedComponents, id: \.self) { component in
                    Text(component)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 5.0)
                                .foregroundColor(Color(UIColor.tertiarySystemFill))
                        }
                }
            }
        }
    }
}

struct AutocompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteView(guess: "41.circle.fill")
    }
}
