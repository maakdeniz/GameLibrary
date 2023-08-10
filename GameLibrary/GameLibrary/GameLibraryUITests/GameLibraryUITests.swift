//
//  GameLibraryUITests.swift
//  GameLibraryUITests
//
//  Created by Mehmet Akdeniz on 12.07.2023.
//

import XCTest

final class GameLibraryUITests: XCTestCase {
    
    func testUI() {
        
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["4.05"].tap()
        
        let gamelibraryGamedetailviewNavigationBar = app.navigationBars["GameLibrary.GameDetailView"]
        let addToFavoritesButton = gamelibraryGamedetailviewNavigationBar.buttons["Add to Favorites"]
        addToFavoritesButton.tap()
        
        let gamesLibraryButton = gamelibraryGamedetailviewNavigationBar.buttons["Games Library"]
        gamesLibraryButton.tap()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favoriler"].tap()
        collectionViewsQuery.cells.otherElements.containing(.staticText, identifier:"Tomb Raider (2013)").element.tap()
        gamelibraryGamedetailviewNavigationBar.buttons["Remove from Favorites"].tap()
        gamelibraryGamedetailviewNavigationBar.buttons["Favorites"].tap()
        tabBar.buttons["Oyunlar"].tap()
        
    }
    
    func testUISearchGames() {
                
        
        let app = XCUIApplication()
        app.launch()
        let searchGamesSearchField = app.searchFields["Search Games ..."]
        searchGamesSearchField.tap()
        searchGamesSearchField.typeText("Grand")
        app.keyboards.buttons["Search"].tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["4.47"]/*[[".cells.staticTexts[\"4.47\"]",".staticTexts[\"4.47\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let gamelibraryGamedetailviewNavigationBar = app.navigationBars["GameLibrary.GameDetailView"]
        gamelibraryGamedetailviewNavigationBar.buttons["Add to Favorites"].tap()
        gamelibraryGamedetailviewNavigationBar.buttons["Remove from Favorites"].tap()
        gamelibraryGamedetailviewNavigationBar.buttons["Games Library"].tap()
        searchGamesSearchField.tap()
                
        
    }
    
   
}
