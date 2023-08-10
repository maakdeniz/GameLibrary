//
//  GamesPageViewModel.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 20.07.2023.
//

import Foundation
import GamesAPI

//MARK: - GamePageViewModelProtocol
protocol GamePageViewModelProtocol: AnyObject {
    var game: Game? { get }
    var gameImageURL: URL? { get }
    
    func didSelectGame()
}
//MARK: - GamePageViewModel
final class GamePageViewModel: GamePageViewModelProtocol {
    var game: Game?
    var gameImageURL: URL? {
        if let imageUrlString = game?.backgroundImage {
            return URL(string: imageUrlString)
        }
        return nil
    }
    
    init(game: Game?) {
        self.game = game
    }
    
    func didSelectGame() {
        if let game = game {
            print("Posting didSelectGame notification with game id: \(String(describing: game.id))")
            NotificationCenter.default.post(name: .didSelectGame, object: game.id)
        }
    }
}

