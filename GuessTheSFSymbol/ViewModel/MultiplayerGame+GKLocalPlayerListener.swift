//
//  Game+GKLocalPlayerListener.swift
//  GameKitRealTime
//
//  Created by Zoe Cutler on 2/20/23.
//

import Foundation
import GameKit

// GKLocalPlayerListener and GKMatchDelegate
extension MultiplayerGame: GKLocalPlayerListener, GKMatchDelegate {
    //Handle when the local player accepts an invite to a match
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        // Present the view controller in the invitation state.
        let viewController = GKMatchmakerViewController(invite: invite)
        viewController?.matchmakerDelegate = self
        rootViewController?.present(viewController!, animated: true, completion: nil)
    }
    
    //Handle when an opponent leaves the match
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
        //Find the index of the player we are talking about
        if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
            opponents.remove(at: index)
        }
    }
    
    //Handle when an opponent sends us match data
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        //Ensure this data is for the current match
        guard currentMatch == match else {
            return
        }
        
        do {
            //Try to decode the data
            if let gamePropertyList: [String: Any] =
                try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                
                // Restore the new correct guess from the property list
                if let date = gamePropertyList["date"] as? Date,
                   let round = gamePropertyList["round"] as? Int,
                   let answer = gamePropertyList["answer"] as? String {
                    var newGuess = Guess(date: date, round: round, answer: .skip)
                    
                    if answer != "" {
                        newGuess.answer = .correct(answer)
                        roundIsFinished = true
                    }
                    
                    //Find the index of the player we are talking about
                    if let index = opponents.firstIndex(where: { $0.gkPlayer.gamePlayerID == player.gamePlayerID }) {
                        opponents[index].guesses.append(newGuess)
                    }
                }
                
                // Get the symbols to guess from the player who generated them
                if let symbols = gamePropertyList["symbolsToGuess"] as? [String] {
                    symbolsToGuess = symbols
                }
            }
        } catch {
            //Handle error loading updated match data
            print("Error updating match data: \(error.localizedDescription)")
        }
    }
}
