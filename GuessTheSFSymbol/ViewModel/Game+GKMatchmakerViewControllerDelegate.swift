//
//  Game+GKMatchmakerViewControllerDelegate.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import GameKit

extension Game: GKMatchmakerViewControllerDelegate {
    //Handle finding a match
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        // Dismiss the view controller.
        viewController.dismiss(animated: true, completion: nil)
        
        // Set the match delegate.
        match.delegate = self
        
        //Update the list of participants
        for player in match.players {
            let newPlayer = Player(gkPlayer: player)
            opponents.append(newPlayer)
            loadAvatar(for: player)
        }
        
        currentMatch = match
        
        //Get list of symbols to guess this round
        symbolsToGuess = Symbols.shared.generateRoundSymbols(for: 10)
        
        isPlayingGame = true
    }
    
    //Handle matchmaker cancellations for localPlayer
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
        resetGame()
    }
    
    //Handle matchmaker failure for localPlayer
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
        resetGame()
    }
}
