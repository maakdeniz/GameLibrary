//
//  MockNetworkManager.swift
//  GameLibraryTests
//
//  Created by Mehmet Akdeniz on 28.07.2023.
//

import XCTest
@testable import GameLibrary
@testable import GamesAPI

class MockNetworkManager: NetworkManagerProtocol {
    
    var gamesResponse: GamesResponse? = .init(results: [
        .init(id: 1, name: "GTA",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80),
        .init(id: 1, name: "METIN 2",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80),
        .init(id: 1, name: "Portal", rating: 3.3,
              released: "Test", backgroundImage: "Test",
              metacritic: 80),
        .init(id: 1, name: "Border",
              rating: 3.3, released: "Test",
              backgroundImage: "Test", metacritic: 80)
    ])
    
    var topRatedGamesResponse: GamesResponse? = .init(results: [.init(id: 1, name: "GTA",
                                                                     rating: 3.3, released: "Test",
                                                                     backgroundImage: "Test", metacritic: 80),
                                                               .init(id: 1, name: "METIN 2",
                                                                     rating: 3.3, released: "Test",
                                                                     backgroundImage: "Test", metacritic: 80),
                                                               .init(id: 1, name: "Portal", rating: 3.3,
                                                                     released: "Test", backgroundImage: "Test",
                                                                     metacritic: 80)
    ])
    
    var gameDetailsResponse: GameDetailsResponse? = .init(id: 1, name: "GTA",
                                                          description: "Test", released: "Test",
                                                          rating: 3.3, backgroundImage: "Test", metacritic: 1)
    
    
    func fetchGames(completion: @escaping (Result<GamesResponse, Error>) -> Void) {
        if let gamesResponse {
            completion(.success(gamesResponse))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }
    
    func fetchTopRatedGames(completion: @escaping (Result<GamesResponse, Error>) -> Void) {
        if let topRatedGamesResponse {
            completion(.success(topRatedGamesResponse))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }

    func fetchGameDetails(gameId: Int, completion: @escaping (Result<GameDetailsResponse, Error>) -> Void) {
        if let gameDetailsResponse = gameDetailsResponse {
            completion(.success(gameDetailsResponse))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }
}
