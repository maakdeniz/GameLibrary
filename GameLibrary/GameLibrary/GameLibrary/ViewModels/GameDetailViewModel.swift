//
//  GameDetailViewModel.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 13.07.2023.
//
import Foundation
import GamesAPI

//MARK: - GameDetailViewModelDelegate
protocol GameDetailViewModelDelegate: AnyObject {
    func gameDetailDidFetch()
    func gameFavoriteStatusDidChange()
}
//MARK: - GameDetailViewModelProtocol
protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    var gameDetail: GameDetailsResponse? { get }
    var gameId: Int? { get }
    var gameTitle: String? { get }
    var gameReleaseDate: String? { get }
    var gameDescription: String? { get }
    var gameImageUrl: String? { get }
    var metacriticRateTitle: String? { get }

    func fetchGameDetails()
    func toGame() -> Game
    func toggleFavoriteStatus()
    func isGameFavorite() -> Bool
}
//MARK: - GameDetailViewModel
final class GameDetailViewModel: GameDetailViewModelProtocol {

    weak var delegate: GameDetailViewModelDelegate?
    var coreDataService: CoreDataHelperProtocol = CoreDataHelper.shared
    var gameDetail: GameDetailsResponse?
    var networkManager: NetworkManagerProtocol = NetworkManager.shared
    init(gameId: Int?) {
        self.gameId = gameId
    }
    
    var gameId: Int?
    var gameTitle: String? {
        return gameDetail?.name
    }
    
    var gameReleaseDate: String? {
        return "Release Date: " + (gameDetail?.released ?? "")
    }
    
    var gameDescription: String? {
        return gameDetail?.description
    }
    
    var gameImageUrl: String? {
       return gameDetail?.backgroundImage
    }
    
    var metacriticRateTitle: String? {
        return "Metacritic Rate: " + String(gameDetail?.metacritic ?? 0)
    }
    
    func fetchGameDetails() {
        guard let gameId else {
            print("ID ALINAMIYOR")
            return }
        networkManager.fetchGameDetails(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let gameDetailsResponse):
                    self?.gameDetail = gameDetailsResponse
                    self?.delegate?.gameDetailDidFetch()
            case .failure(let error):
                // Handle error
                print("Failed to fetch game details: \(error)")
            }
        }
    }
    
    func toGame() -> Game {
        return Game(
            id: gameDetail?.id,
            name: gameDetail?.name,
            rating: gameDetail?.rating,
            released: gameDetail?.released,
            backgroundImage: gameDetail?.backgroundImage,
            metacritic: gameDetail?.metacritic
        )
    }
    
    func toggleFavoriteStatus() {
        guard let gameId else { return }
        if coreDataService.isFavorite(gameId: gameId) {
            coreDataService.removeFromFavorites(game: toGame())
        } else {
            coreDataService.addToFavorites(game: toGame())
        }
        delegate?.gameFavoriteStatusDidChange()
    }
    
    func isGameFavorite() -> Bool {
        guard let gameId else { return false }
        return coreDataService.isFavorite(gameId: gameId)
    }
}
