//
//  Game.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI
import GameKit

@MainActor class Game: NSObject, ObservableObject, GKMatchDelegate, GKLocalPlayerListener, GKMatchmakerViewControllerDelegate {
    @Published var localPlayer: Player?
    @Published var isAuthenticated = false
    
    @Published var isPlayingGame = false
    @Published var currentMatch: GKMatch?
    @Published var opponents: [Player] = []
    
    @Published var minPlayers = 2
    @Published var maxPlayers = 4
    @Published var numberOfRounds = 10
    
    @Published var round: Int = 0
    @Published var roundIsFinished = false
    @Published var symbolsToGuess: [String] = []
    
#warning("Remove this sample data init")
    init(withSampleData: Bool) {
        super.init()
        if withSampleData {
            localPlayer = Player(gkPlayer: GKPlayer())
            opponents = [Player(gkPlayer: GKPlayer())]
            symbolsToGuess = Symbols.shared.generateRoundSymbols(for: numberOfRounds)
        }
    }
    
    /// The root view controller of the window.
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    /// Authenticates the local player (i.e.: the user) with GameCenter.
    func authenticateLocalPlayer() {
        // Set the authentication handler that GameKit invokes.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If the view controller is non-nil, present it to the player so they can
                // perform some necessary action to complete authentication.
                self.rootViewController?.present(viewController, animated: true, completion: nil)
                return
            }
            if error != nil {
                // If you can’t authenticate the player, disable Game Center features in your game.
                print("Error: \(error!.localizedDescription).")
                return
            }
            
            // A value of nil for viewController indicates successful authentication, and you can access
            // local player properties.
            GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
                if let image = image {
                    // Create a Participant object to store the local player data.
                    self.localPlayer = Player(gkPlayer: GKLocalPlayer.local,
                                              avatar: Image(uiImage: image))
                }
                if error != nil {
                    // Handle an error if it occurs.
                    print("Error: \(error!.localizedDescription).")
                }
            }
            
            // Register for turn-based invitations and other events.
            GKLocalPlayer.local.register(self)
            
            // Enable the start game button.
            self.isAuthenticated = true
        }
    }
    
    /// Resets the game data to default
    func resetGame() {
        isPlayingGame = false
        opponents = []
        round = 0
        roundIsFinished = false
        currentMatch?.delegate = nil
        currentMatch = nil
    }
    
    /// Creates a new match request and shows the matchmaker view controller to find opponents.
    func startGame() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 4
        request.inviteMessage = "\(localPlayer?.gkPlayer.displayName ?? "Unknown Player") wants to play SFGuess with you!"
        
        if let viewController = GKMatchmakerViewController(matchRequest: request) {
            viewController.matchmakerDelegate = self
            viewController.canStartWithMinimumPlayers = true
            
            self.rootViewController?.present(viewController, animated: true, completion: nil)
        } else {
            //View controller failed to present, handle this somehow
        }
    }
    
    /// Loads an avatar for a specific opponent, and places it in the correct opponent's Player struct
    func loadAvatar(for player: GKPlayer) {
        Task {
            let uiImage = try await player.loadPhoto(for: .small)
            if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
                opponents[index].avatar = Image(uiImage: uiImage)
            }
        }
    }
    
    /// Check if the guess is correct
    func validateGuess(_ guess: String) {
        let guessCleaned = guess.filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        let correctAnswerCleaned = symbolsToGuess[round].filter({ !$0.isWhitespace && !$0.isPunctuation && !$0.isNewline }).lowercased()
        
        if guessCleaned == correctAnswerCleaned {
            if !(localPlayer?.correctGuesses.contains(where: { $0.round == round }) ?? true) {
                let newCorrectGuess = CorrectGuess(round: round, answer: symbolsToGuess[round])
                localPlayer?.correctGuesses.append(newCorrectGuess)
                sendNewCorrectGuess(newCorrectGuess)
                roundIsFinished = true
            }
        }
    }
    
    /// Check whether a player had a correct guess for this round
    func playerGuessedCorrectly(_ id: UUID) -> Bool {
        if let opponent = opponents.first(where: { $0.id == id }) {
            if opponent.correctGuesses.contains(where: { $0.round == round }) {
                return true
            }
        }
        
        if localPlayer?.id == id {
            if localPlayer!.correctGuesses.contains(where: { $0.round == round }) {
                return true
            }
        }
        
        return false
    }
    
    /// Send updated score to all opponents
    func sendNewCorrectGuess(_ guess: CorrectGuess) {
        do {
            var gamePropertyList: [String: Any] = [:]
            
            // Add the local player's new correct guess
            gamePropertyList["newCorrectGuess"] = guess
            
            let gameData = try PropertyListSerialization.data(fromPropertyList: gamePropertyList, format: .binary, options: 0)
            try currentMatch?.sendData(toAllPlayers: gameData, with: .reliable)
        } catch {
            //Handle error sending new correct guess
            print("Error sending new correct guess: \(error.localizedDescription)")
        }
    }
    
    /// Disconnects from the match and resets the game data
    func quitGame() {
        currentMatch?.disconnect()
        resetGame()
    }
}
