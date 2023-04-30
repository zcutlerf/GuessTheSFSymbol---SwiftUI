//
//  AutocompleteView.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/6/23.
//

import SwiftUI

struct AutocompleteView: View {
    @Binding var guessText: String
    
    var latestComponent: String {
        if guessText.contains(".") {
            let lastPeriodIndex = guessText.lastIndex(of: ".")!
            if guessText.last == "." {
                return ""
            }
            var suffix = guessText.suffix(from: lastPeriodIndex)
            suffix.removeFirst()
            return String(suffix)
        } else {
            return guessText
        }
    }
    
    var suggestedComponents: [String] {
        let latestComponentCleaned = latestComponent.filter({ !$0.isWhitespace }).lowercased()
        
        if latestComponent == "" {
            return []
        } else {
            let filteredComponents = Symbols.shared.components.filter({ $0.hasPrefix(latestComponentCleaned) })
            let endIndex = min(filteredComponents.endIndex, 5)
            return Array<String>(filteredComponents[0..<endIndex])
        }
    }
    
    var body: some View {
        Group {
            if !suggestedComponents.isEmpty {
                ScrollView([.horizontal]) {
                    HStack {
                        ForEach(suggestedComponents, id: \.self) { component in
                            Button {
                                autocomplete(with: component)
                            } label: {
                                Text(component + ".")
                            }
                            .padding(5)
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .padding(10)
                .background(.bar)
            }
        }
    }
    
    func autocomplete(with component: String) {
        if guessText.contains(".") {
            let lastPeriodIndex = guessText.lastIndex(of: ".")!
            
            var guessTextWithoutLastPartialComponent = String(guessText.prefix(upTo: lastPeriodIndex))
            guessTextWithoutLastPartialComponent.append(".")
            guessTextWithoutLastPartialComponent.append(component)
            
            guessText = guessTextWithoutLastPartialComponent + "."
        } else {
            guessText = component + "."
        }
    }
}

struct AutocompleteView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteView(guessText: .constant("41.circle.f"))
    }
}
