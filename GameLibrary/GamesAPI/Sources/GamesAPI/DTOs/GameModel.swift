//
//  GameModel.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import Foundation

public struct GamesResponse: Codable {
    public let results: [Game]
}

public struct Game: Codable {
    public let id: Int?
    public let name: String?
    public let rating: Double?
    public let released: String?
    public let backgroundImage: String?
    public let metacritic: Int?
    public var isTopRated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, released
        case backgroundImage = "background_image"
        case metacritic
        case isTopRated
    }
    public init(id: Int?, name: String?, rating: Double?, released: String?, backgroundImage: String?, metacritic: Int?, isTopRated: Bool? = false) {
            self.id = id
            self.name = name
            self.rating = rating
            self.released = released
            self.backgroundImage = backgroundImage
            self.metacritic = metacritic
            self.isTopRated = isTopRated
        }
}

// For game details
public struct GameDetailsResponse: Codable {
    public let id: Int?
    public let name: String?
    public let description: String?
    public let released: String?
    public let rating: Double?
    public let backgroundImage: String?
    //public let developers: [Developer]?
    public let metacritic: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, released, rating
        case backgroundImage = "background_image"
        case metacritic
        case description = "description_raw"
    }
}

public struct Developer: Codable {
    public let id: Int?
    public let name: String?
    public let gamesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case gamesCount = "games_count"
    }
}
