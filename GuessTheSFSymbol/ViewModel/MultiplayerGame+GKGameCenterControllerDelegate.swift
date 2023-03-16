//
//  MultiplayerGame+GameCenterDashboardable.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/16/23.
//

import GameKit

// GKGameCenterControllerDelegate
extension MultiplayerGame: GKGameCenterControllerDelegate {
    func presentGameCenterVCLeaderboards() {
        let viewController = GKGameCenterViewController(state: .leaderboards)
        viewController.gameCenterDelegate = self
        self.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
