//
//  Game.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import SwiftUI
import GameKit

@MainActor class MultiplayerGame: NSObject, ObservableObject {
    @Published var localPlayer: Player?
    @Published var isAuthenticated = false
    
    @Published var isPlayingGame = false
    @Published var currentMatch: GKMatch?
    @Published var opponents: [Player] = []
    var hasOpponents: Bool {
        if opponents.count == 0 {
            return false
        } else {
            return true
        }
    }
    
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
        localPlayer?.guesses = []
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
            if !(localPlayer?.guesses.contains(where: { $0.round == round }) ?? true) {
                let newCorrectGuess = Guess(round: round, answer: .correct(symbolsToGuess[round]))
                localPlayer?.guesses.append(newCorrectGuess)
                sendNewGuess(newCorrectGuess)
                roundIsFinished = true
            }
        }
    }
    
    /// Check whether a player had a correct guess for this round
    func playerGuessedCorrectly(_ id: UUID) -> Bool {
        if let opponent = opponents.first(where: { $0.id == id }) {
            if opponent.correctAnswers.contains(where: { $0.round == round }) {
                return true
            }
        }
        
        if localPlayer?.id == id {
            if localPlayer!.correctAnswers.contains(where: { $0.round == round }) {
                return true
            }
        }
        
        return false
    }
    
    func skipRound() {
        let newSkip = Guess(round: round, answer: .skip)
        localPlayer?.guesses.append(newSkip)
        sendNewGuess(newSkip)
    }
    
    var allPlayersHaveSkipped: Bool {
        guard let localPlayer = localPlayer else {
            return false
        }
        
        let allPlayers = opponents + [localPlayer]
        
        let playersWhoHaveSkipped = allPlayers.filter({
            $0.guesses.contains(where: {
                if $0.round != round {
                    return false
                }
                
                switch $0.answer {
                case .correct(_):
                    return false
                case .skip:
                    return true
                }
            })
        })
        
        return allPlayers.count == playersWhoHaveSkipped.count
    }
    
    /// Send initial list of symbols to guess generated by the player with the first name in alphabetical order.
    func getSymbolsToGuess() {
        guard let localPlayer = localPlayer else {
            return
        }
        
        var playersAlphabetical = opponents + [localPlayer]
        playersAlphabetical.sort(by: { $0.gkPlayer.displayName > $1.gkPlayer.displayName })
        
        if localPlayer.gkPlayer.gamePlayerID == playersAlphabetical.first!.gkPlayer.gamePlayerID {
            symbolsToGuess = Symbols.shared.generateRoundSymbols(for: numberOfRounds)
            
            sendSymbolsToGuess()
            
            // Try again, in case it didn't work the first time.
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                sendSymbolsToGuess()
            }
        }
        
        //Otherwise, wait for symbols to be sent from another player.
    }
    
    func sendSymbolsToGuess() {
        do {
            var gamePropertyList: [String: Any] = [:]
            
            // Add the local player's new correct guess
            gamePropertyList["symbolsToGuess"] = symbolsToGuess
            
            let gameData = try PropertyListSerialization.data(fromPropertyList: gamePropertyList, format: .binary, options: 0)
            try currentMatch?.sendData(toAllPlayers: gameData, with: .reliable)
        } catch {
            //Handle error sending new correct guess
            print("Error sending list of symbols to guess: \(error.localizedDescription)")
        }
    }
    
    /// Send updated score to all opponents
    func sendNewGuess(_ guess: Guess) {
        do {
            var gamePropertyList: [String: Any] = [:]
            
            // Add the local player's new correct guess
            gamePropertyList["date"] = guess.date
            gamePropertyList["round"] = guess.round
            
            switch guess.answer {
            case .correct(let answer):
                gamePropertyList["answer"] = answer
            case .skip:
                gamePropertyList["answer"] = ""
            }
            
            let gameData = try PropertyListSerialization.data(fromPropertyList: gamePropertyList, format: .binary, options: 0)
            try currentMatch?.sendData(toAllPlayers: gameData, with: .reliable)
        } catch {
            //Handle error sending new correct guess
            print("Error sending new correct guess: \(error.localizedDescription)")
        }
    }
    
    var gameIsOver: Bool {
        if round == numberOfRounds - 1 && roundIsFinished {
            return true
        } else {
            return false
        }
    }
    
    /// Disconnects from the match and resets the game data
    func quitGame() {
        currentMatch?.disconnect()
        resetGame()
    }
}
