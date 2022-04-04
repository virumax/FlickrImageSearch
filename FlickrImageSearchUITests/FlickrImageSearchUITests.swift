//
//  FlickrImageSearchUITests.swift
//  FlickrImageSearchUITests
//
//  Created by Virendra Ravalji on 03/04/22.
//

import XCTest

class FlickrImageSearchUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageSearchUI() throws {
        let app = XCUIApplication()
        let element = app.windows.children(matching: .other).element
        let searchField = element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Cat")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let promise = expectation(description: "Completion handler invoked")
        let collectionViewsQuery = app.collectionViews
        let collectionView = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            promise.fulfill()
        }
       
        wait(for: [promise], timeout: 5)
        XCTAssertTrue(collectionView.exists)
    }

    func testImageSearchUIForInvalidInput() throws {
        let app = XCUIApplication()
        let element = app.windows.children(matching: .other).element
        let searchField = element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("@#$@$@$@$@SF@$#@$##@SS#@#@#$@$!%#%$^%^&J^%&")
        app.buttons["Search"].tap()
        
        let promise = expectation(description: "Completion handler invoked")
        let collectionViewsQuery = app.collectionViews
        let collectionView = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            promise.fulfill()
        }
       
        wait(for: [promise], timeout: 5)
        XCTAssertFalse(collectionView.exists)
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
