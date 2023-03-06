//
//  SymbolService.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/21/23.
//

import Foundation

struct Symbols {
    static let shared = Symbols()
    
    var practiceSymbolNames: [String] = []
    var easySymbolNames: [String] = []
    var mediumSymbolNames: [String] = []
    var hardSymbolNames: [String] = []
    
    var components: [String] = []
    
    private init() {
        if let path = Bundle.main.path(forResource: "SFSymbols", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                hardSymbolNames = data.components(separatedBy: .newlines)
                hardSymbolNames.removeAll(where: { $0.isEmpty })
                
                for name in hardSymbolNames {
                    let numberOfComponents = name.components(separatedBy: ".").count
                    if numberOfComponents <= 4 {
                        mediumSymbolNames.append(name)
                    } else if numberOfComponents <= 2 {
                        easySymbolNames.append(name)
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
            } catch {
                print(error)
            }
        }
    }
    
    func generateRoundSymbols(for count: Int) -> [String] {
        var selectedSymbols: [String] = []
        for _ in 0..<count {
            let newSymbol = randomSymbol(from: .hard)
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
