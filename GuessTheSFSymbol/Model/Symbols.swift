//
//  SymbolService.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/21/23.
//

import Foundation

struct Symbols {
    static let shared = Symbols()
    
    var symbolNames: [String] = []
    
    private init() {
//        if let path = Bundle.main.path(forResource: "SFSymbols", ofType: "txt") {
        #warning("Using simple symbols for testing")
        if let path = Bundle.main.path(forResource: "SimpleSymbols", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                symbolNames = data.components(separatedBy: .newlines)
                symbolNames.removeAll(where: { $0.isEmpty })
            } catch {
                print(error)
            }
        }
    }
    
    func generateRoundSymbols(for count: Int) -> [String] {
        var selectedSymbols: [String] = []
        for _ in 0..<count {
            let newSymbol = randomSymbol()
            selectedSymbols.append(newSymbol)
        }
        
        return selectedSymbols
    }
    
    private func randomSymbol() -> String {
        var symbol = self.symbolNames.randomElement() ?? "person"
        symbol.removeAll(where: { $0.isWhitespace || $0.isNewline })
        return symbol
    }
}
