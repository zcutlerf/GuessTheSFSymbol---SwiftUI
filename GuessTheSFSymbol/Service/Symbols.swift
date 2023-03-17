//
//  SymbolService.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/21/23.
//

import Foundation

class Symbols {
    static let shared = Symbols()
    
    /// A select set of 1-component symbols.
    var practiceSymbolNames: [String] = []
    /// All symbols that are 1-2 components.
    var easySymbolNames: [String] = []
    /// All symbols that are 2-4 components, with some symbols that are 1 component.
    var mediumSymbolNames: [String] = []
    /// All symbols that are 3+ components, with some symbols that are 2 components.
    var hardSymbolNames: [String] = []
    /// All symbols.
    var multiplayerSymbolNames: [String] = []
    
    /// All symbols, separated into individual components (words).
    var components: [String] = []
    
    private init() {
        if let path = Bundle.main.path(forResource: "SFSymbols", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                multiplayerSymbolNames = data.components(separatedBy: .newlines)
                multiplayerSymbolNames.removeAll(where: { $0.isEmpty })
                
                for name in multiplayerSymbolNames {
                    let numberOfComponents = name.components(separatedBy: ".").count
                    
                    if numberOfComponents <= 2 {
                        easySymbolNames.append(name)
                    }
                    
                    if numberOfComponents <= 4 {
                        if numberOfComponents != 1 || Bool.random() {
                            mediumSymbolNames.append(name)
                        }
                    }
                    
                    if numberOfComponents >= 2 {
                        if numberOfComponents != 2 || Int.random(in: 1...3) == 1 {
                            hardSymbolNames.append(name)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        
        if let path = Bundle.main.path(forResource: "SimpleSymbols", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                practiceSymbolNames = data.components(separatedBy: .newlines)
                practiceSymbolNames.removeAll(where: { $0.isEmpty })
            } catch {
                print(error)
            }
        }
        
        if let path = Bundle.main.path(forResource: "SymbolComponents", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                components = data.components(separatedBy: .newlines)
                components.removeAll(where: { $0.isEmpty })
                components.sort()
            } catch {
                print(error)
            }
        }
    }
    
    func generateMultiplayerRoundSymbols(for count: Int) -> [String] {
        var selectedSymbols: [String] = []
        for _ in 0..<count {
            var newSymbol = multiplayerSymbolNames.randomElement() ?? "person"
            newSymbol.removeAll(where: { $0.isWhitespace || $0.isNewline })
            selectedSymbols.append(newSymbol)
        }
        
        return selectedSymbols
    }
    
    func randomSymbol(from difficulty: Difficulty) -> String {
        var symbol = difficulty.symbolNames.randomElement() ?? "person"
        symbol.removeAll(where: { $0.isWhitespace || $0.isNewline })
        return symbol
    }
}
