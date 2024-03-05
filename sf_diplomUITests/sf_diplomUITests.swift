//
//  sf_diplomUITests.swift
//  sf_diplomUITests
//
//  Created by Иван on 05.03.2024.
//

import XCTest

final class sf_diplomUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

class FilmListUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testFilmListViewController() throws {
        app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.otherElements["filmListViewController"].exists)
        
        let collectionView = app.collectionViews["collectionView"]
        XCTAssertTrue(collectionView.exists)
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        
        firstCell.tap()
    }
}
