//
//  GamesViewModelTests.swift
//  GameLibraryTests
//
//  Created by Mehmet Akdeniz on 28.07.2023.
//

import XCTest
@testable import GameLibrary
@testable import GamesAPI


class GamesViewModelTests: XCTestCase {

    var gamesViewModel: GamesViewModelProtocol!
    var mockNetworkManager: MockNetworkManager!
    
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        gamesViewModel = GamesViewModel()
        gamesViewModel.networkManager = mockNetworkManager
    }
    
    func testFetchGames() {
        XCTAssertFalse(self.gamesViewModel.gamesCount > 0)
        gamesViewModel.fetchGames()
        XCTAssertTrue(self.gamesViewModel.gamesCount > 0)
    }
    
    
    func testFetchTopRatedGames() {
        XCTAssertFalse(!self.gamesViewModel.topRatedGames.isEmpty)
        gamesViewModel.fetchTopRatedGames()
        XCTAssertTrue(!self.gamesViewModel.topRatedGames.isEmpty)
    }
    
    func testSearchGames() {
        let query = "GTA"
        gamesViewModel.fetchGames()
        gamesViewModel.searchGames(query: query)
        let result = gamesViewModel.gamesCount
        XCTAssertTrue(result > 0)
        XCTAssertEqual(gamesViewModel.searchResults.first?.name, "GTA")
    }
        
    func testIsSearchActive() {
        gamesViewModel.searchQuery = "test"

        let isSearchActive = gamesViewModel.isSearchActive()

        XCTAssertTrue(isSearchActive)
    }
}
