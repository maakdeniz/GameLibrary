//
//  FavoritesViewModelTests.swift
//  GameLibraryTests
//
//  Created by Mehmet Akdeniz on 28.07.2023.
//

import XCTest
@testable import GameLibrary
@testable import GamesAPI

class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModel!
    var mockCoreData = MockCoreDataHelper()
    
    override func setUp() {
        viewModel = FavoritesViewModel()
        viewModel.coreDataService = mockCoreData
    }
    
    func testFetchFavoritesGames() {
        XCTAssertTrue(viewModel.favoritesGameCount == 0)
        viewModel.startUpdating()
        XCTAssertFalse(viewModel.favoritesGameCount == 0)
    }
    
}
