//
//  GuessTheSFSymbolApp.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 2/22/23.
//

import SwiftUI

@main
struct GuessTheSFSymbolApp: App {
    @StateObject var game = Game(withSampleData: false)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(game)
        }
    }
}
