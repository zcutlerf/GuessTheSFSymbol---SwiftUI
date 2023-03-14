//
//  MultiplayerService.swift
//  GuessTheSFSymbol
//
//  Created by Zoe Cutler on 3/14/23.
//

import SwiftUI
import UIKit
import GameKit

actor MultiplayerService {
    static func loadPhoto(for player: GKPlayer, of size: GKPlayer.PhotoSize) async throws -> Image {
        let uiImage = try await player.loadPhoto(for: size)
        return Image(uiImage: uiImage)
    }
}
