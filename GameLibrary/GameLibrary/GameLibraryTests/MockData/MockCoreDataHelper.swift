//
//  MockCoreDataHelper.swift
//  GameLibraryTests
//
//  Created by Mehmet Akdeniz on 28.07.2023.
//

import XCTest
@testable import GameLibrary
@testable import GamesAPI

class MockCoreDataHelper: CoreDataHelperProtocol {
    
    var mockData: [Game] = [
        .init(id: 1, name: "GTA",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80),
        .init(id: 2, name: "METIN 2",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80),
        .init(id: 3, name: "Portal", rating: 3.3,
              released: "Test", backgroundImage: "Test",
              metacritic: 80),
        .init(id: 4, name: "Border",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80)
    ]
    
    
    
    func addToFavorites(game: Game) {
        mockData.append(game)
    }
    
    func removeFromFavorites(game: Game) {
        mockData = mockData.filter({ $0.id != game.id })
    }
    
    func isFavorite(gameId: Int) -> Bool {
        mockData.contains {  $0.id == gameId }
    }
    
    func fetchFavoritesGames() -> [Game] {
        return mockData
    }
    
    
}

