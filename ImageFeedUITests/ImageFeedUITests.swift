//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Илья Геннадьевич on 05.02.2026.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
            app.buttons["Authenticate"].tap()
            
            let webView = app.webViews["UnsplashWebView"]

            XCTAssertTrue(webView.waitForExistence(timeout: 10))

            let loginTextField = webView.descendants(matching: .textField).element
            XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))

            loginTextField.tap()
            loginTextField.typeText("email")
            webView.swipeUp()

            let passwordTextField = webView.descendants(matching: .secureTextField).element
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))

            passwordTextField.tap()
            passwordTextField.typeText("password")

            webView.buttons["Login"].tap()

            let tablesQuery = app.tables
            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

            XCTAssertTrue(cell.waitForExistence(timeout: 10))
        }

    func testFeed() throws {
        // тестируем сценарий ленты
            let tablesQuery = app.tables

            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            XCTAssertTrue(cell.waitForExistence(timeout: 10))
            cell.swipeUp()

            let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
            XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))

            cellToLike.buttons["like button off"].tap()
            XCTAssertTrue(cellToLike.buttons["like button on"].waitForExistence(timeout: 5))
            cellToLike.buttons["like button on"].tap()
            XCTAssertTrue(cellToLike.buttons["like button off"].waitForExistence(timeout: 5))

            cellToLike.tap()

            let image = app.scrollViews.images.element(boundBy: 0)
            XCTAssertTrue(image.waitForExistence(timeout: 10))

            // Zoom in
            image.pinch(withScale: 3, velocity: 1)
            // Zoom out
            image.pinch(withScale: 0.5, velocity: -1)

            let navBackButtonWhiteButton = app.buttons["nav back button white"]
            navBackButtonWhiteButton.tap()
        }

    func testProfile() throws {
        // тестируем сценарий профиля
            let feedCell = app.tables.children(matching: .cell).element(boundBy: 0)
            XCTAssertTrue(feedCell.waitForExistence(timeout: 10))
            app.tabBars.buttons.element(boundBy: 1).tap()

            XCTAssertTrue(app.staticTexts["Name"].exists)
            XCTAssertTrue(app.staticTexts["@name_"].exists)

            app.buttons["logout button"].tap()

            app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

            XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        }
}
