//
//  NetworkManager.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import Foundation

public protocol NetworkManagerProtocol {
    func fetchGames(completion: @escaping (Result<GamesResponse, Error>) -> Void)
    func fetchTopRatedGames(completion: @escaping (Result<GamesResponse, Error>) -> Void)
    func fetchGameDetails(gameId: Int, completion: @escaping (Result<GameDetailsResponse, Error>) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    
    public static let shared = NetworkManager()
    static let apiKey = "d6c93aa38c6a42a386c0be27e85289e3"
    private let baseURL = "https://api.rawg.io/api/games"
    
    private init () {}
    
    private func decodeData<T: Decodable>(_ data: Data, into type: T.Type) -> Result<T, Error> {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(type, from: data)
            return .success(response)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    public func fetchGames(completion: @escaping (Result<GamesResponse, Error>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: NetworkManager.apiKey),
            URLQueryItem(name: "page_size", value: "100")
        ]
        
        guard let url = components?.url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data,reponse,error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            let result: Result<GamesResponse, Error> = self.decodeData(data, into: GamesResponse.self)
            completion(result)
        }
        task.resume()
    }
    
    public func fetchTopRatedGames(completion: @escaping (Result<GamesResponse, Error>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: NetworkManager.apiKey),
        ]
        
        guard let url = components?.url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data,reponse,error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            let result: Result<GamesResponse, Error> = self.decodeData(data, into: GamesResponse.self)
            completion(result)
        }
        task.resume()
    }

    public func fetchGameDetails(gameId: Int, completion: @escaping (Result<GameDetailsResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(baseURL)/\(gameId)")
        components?.queryItems = [URLQueryItem(name: "key", value: NetworkManager.apiKey)]
        
        guard let url = components?.url else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            let result: Result<GameDetailsResponse, Error> = self.decodeData(data, into: GameDetailsResponse.self)
            completion(result)
        }
        task.resume()
    }
}

