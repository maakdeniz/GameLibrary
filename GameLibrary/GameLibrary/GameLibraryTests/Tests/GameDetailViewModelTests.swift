//
//  GameLibraryTests.swift
//  GameLibraryTests
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import XCTest
@testable import GameLibrary
@testable import GamesAPI


class MockDelegate: GameDetailViewModelDelegate {
    var didFetchGameDetail = false
    var didChangeFavoriteStatus = false
    
    func gameDetailDidFetch() {
        didFetchGameDetail = true
    }
    
    func gameFavoriteStatusDidChange() {
        didChangeFavoriteStatus = true
    }
}


class GameDetailViewModelTests: XCTestCase {
    var viewModel: GameDetailViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockDelegate: MockDelegate!
    var mockCoreData = MockCoreDataHelper()
    
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = GameDetailViewModel(gameId: 1)
        viewModel.networkManager = mockNetworkManager
        mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate
        viewModel.coreDataService = mockCoreData
    }
    
    func testFetchGameDetailsSuccess() {
        XCTAssertNil(viewModel.gameDetail)
        viewModel.fetchGameDetails()
        XCTAssertNotNil(viewModel.gameDetail)
        XCTAssertTrue(mockDelegate.didFetchGameDetail)
    }
        
    func testToggleFavoriteStatus() {
        viewModel.fetchGameDetails()
        let isFavorite = viewModel.isGameFavorite()
        viewModel.toggleFavoriteStatus()
        XCTAssertNotEqual(isFavorite, viewModel.isGameFavorite())
    }
    
}




