//
//  CoreDataHelper.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 14.07.2023.
//

import CoreData
import UIKit
import GamesAPI

//MARK: - CoreDataHelperProtocol
protocol CoreDataHelperProtocol {
    func addToFavorites(game: Game)
    func removeFromFavorites(game: Game)
    func isFavorite(gameId: Int) -> Bool
    func fetchFavoritesGames() -> [Game]
}
//MARK: - CoreDataHelper
class CoreDataHelper: CoreDataHelperProtocol {
 
    static let shared: CoreDataHelperProtocol = CoreDataHelper()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameLibrary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addToFavorites(game: Game) {
        if !isFavorite(gameId: game.id ?? 0) {
            let context = persistentContainer.viewContext
            let favoriteGame = FavoriteGame(context: context)
            favoriteGame.id = Int64(game.id ?? 0)
            favoriteGame.name = game.name
            favoriteGame.backgroundImage = game.backgroundImage
            favoriteGame.releaseDate = game.released
            favoriteGame.metacriticRate = Int64(Double(game.rating ?? 0))

            saveContext()
        }
    }
    
    func removeFromFavorites(game: Game) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", game.id ?? 0)
        
        do {
            let favoriteGames = try context.fetch(fetchRequest)
            for game in favoriteGames {
                context.delete(game)
            }
            
            saveContext()
        } catch {
            //print("Failed to remove from favorites: \(error)")
        }
    }
    
    func fetchFavorites() -> [FavoriteGame] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        
        do {
            let favoriteGames = try context.fetch(fetchRequest)
            return favoriteGames
        } catch {
            //print("Failed to fetch favorites: \(error)")
            return []
        }
    }
    
    func isFavorite(gameId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", gameId)

        do {
            let fetchResults = try persistentContainer.viewContext.fetch(fetchRequest)
            return !fetchResults.isEmpty
        } catch {
            //print("Failed to check if game is favorite: \(error)")
        }
        
        return false
    }
    
    func fetchFavoritesGames() -> [Game] {
        do {
            let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            
            return result.compactMap({ (favoriteGame) in
                let id = favoriteGame.id
                let rating = favoriteGame.metacriticRate
                let metacritic = favoriteGame.rating
                if let name = favoriteGame.name, let released = favoriteGame.releaseDate, let backgroundImage = favoriteGame.backgroundImage {
                    let game = Game(id: Int(id),
                                    name: name,
                                    rating: Double(rating),
                                    released: released,
                                    backgroundImage: backgroundImage,
                                    metacritic: Int(metacritic))
                    return game
                    
                }
                return nil
            })
        } catch {
            return []
        }
        
    }

}

