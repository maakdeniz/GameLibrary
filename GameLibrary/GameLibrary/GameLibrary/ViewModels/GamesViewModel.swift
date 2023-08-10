//
//  GamesViewModel.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import Foundation
import GamesAPI

//MARK: - GamesViewModelDelegate
protocol GamesViewModelDelegate: AnyObject {
    func gamesDidUpdate()
    func topRatedGamesDidUpdate()
    func searchResultsDidUpdate()
}
//MARK: - GamesViewModelProtocol
protocol GamesViewModelProtocol {
    
    func fetchGames()
    func fetchTopRatedGames()
    func searchGames(query: String)
    func gameForItem(at indexPath: IndexPath,
                     isSearching: Bool) -> Game?
    func isSearchActive() -> Bool
    
    var delegate: GamesViewModelDelegate? { get set }
    var onUpdateSearchResults: (() -> Void)? { get }
    var gamesCount: Int { get }
    var searchResultCount: Int { get }
    var searchQuery: String { get set }
    var games: [Game] { get }
    var topRatedGames: [Game] { get }
    var searchResults: [Game] { get set }
    var networkManager : NetworkManagerProtocol { get set }
}
//MARK: - GamesViewModel
final class GamesViewModel: GamesViewModelProtocol {
    
    weak var delegate: GamesViewModelDelegate?
    
    var gamesCount: Int {
        games.count - 3
    }
    var searchResultCount: Int {
        searchResults.count
    }
    var searchQuery: String = ""
    var games: [Game] = []
    var topRatedGames: [Game] = []
    var searchResults: [Game] = []
    var networkManager : NetworkManagerProtocol = NetworkManager.shared
    var onUpdateSearchResults: (() -> Void)?
    
    func fetchGames() {
        
        networkManager.fetchGames { [weak self] result in
            switch result {
            case .success(let gamesResponse):
                    self?.games = gamesResponse.results
                    self?.delegate?.gamesDidUpdate()
            case .failure(let error):
                // Handle error
                print("Failed to fetch games: \(error)")
            }
        }
    }
    
    func fetchTopRatedGames() {
        
        networkManager.fetchTopRatedGames { [weak self] result in
            switch result {
            case .success(let gamesResponse):
                    self?.topRatedGames = Array(gamesResponse.results.prefix(3)).map { game in
                        var mutableGame = game
                        mutableGame.isTopRated = true
                        return mutableGame
                    }
                    self?.delegate?.topRatedGamesDidUpdate()
            case .failure(let error):
                print("Failed to fetch top rated games: \(error)")
            }
        }
    }
    
    func searchGames(query: String) {
        searchResults = games.filter {
            $0.name?.lowercased().contains(query.lowercased()) ?? false
        }
        onUpdateSearchResults?()
        delegate?.searchResultsDidUpdate()
    }
    
    func gameForItem(at indexPath: IndexPath, isSearching: Bool) -> Game? {
        if isSearching {
            if indexPath.row >= searchResults.count {
                return nil
            }
            return searchResults[indexPath.row]
        } else {
            if indexPath.row + 3 >= games.count {
                return nil
            }
            return games[indexPath.row + 3]
        }
    }
    
    func isSearchActive() -> Bool {
        return searchQuery.count >= 3
    }
}
