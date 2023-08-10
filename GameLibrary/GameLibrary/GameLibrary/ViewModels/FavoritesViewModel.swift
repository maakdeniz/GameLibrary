//
//  FavoritesViewModel.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 14.07.2023.
//

import Foundation
import CoreData
import GamesAPI

//MARK: - FavoritesViewModelDelegate
protocol FavoritesViewModelDelegate: AnyObject {
    func favoriteGamesDidUpdate()
}
//MARK: - FavoritesViewModelProtocol
protocol FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate? { get set }
    var favoritesGameCount: Int? { get }
    
    func startUpdating()
    func isFavoritesEmpty() -> Bool
    func getGameAt(_ index: Int) -> Game
}
//MARK: - FavoritesViewModel
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    var coreDataService: CoreDataHelperProtocol = CoreDataHelper.shared
    weak var delegate: FavoritesViewModelDelegate?
    var favoriteGames: [Game] = [] {
        didSet {
            delegate?.favoriteGamesDidUpdate()
        }
    }
    var favoritesGameCount: Int? {
        favoriteGames.count
    }
    func startUpdating() {
        fetchFavoriteGames()
    }
    private func fetchFavoriteGames() {
        favoriteGames = coreDataService.fetchFavoritesGames()
    }
    
    func isFavoritesEmpty() -> Bool {
        return favoriteGames.isEmpty
    }

    func getGameAt(_ index: Int) -> Game {
        return favoriteGames[index]
    }
    
}

