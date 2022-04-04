//
//  FlickrImageSearchTests.swift
//  FlickrImageSearchTests
//
//  Created by Virendra Ravalji on 03/04/22.
//

import XCTest
@testable import FlickrImageSearch

class FlickrImageSearchTests: XCTestCase {
    //var sut: Presenter!
    var sut: Router!
    var viewController: View!
    var service: ImageSearchClient!
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ImageSearchRouter.start()
        viewController = sut.entry
        service = ImageSearchClient()
    }

    override func tearDownWithError() throws {
        sut = nil
        viewController = nil
        service = nil
        try super.tearDownWithError()
    }

    func testImageSearchClient() throws {
        let promise = expectation(description: "Completion handler invoked")
        var stat: String?
        var responseTest: Response?
        var errorTest: DataResponseError?
        service.sendRequest(parameters: ["text": "Cat"], page: 1) { response, error in
            stat = response?.stat
            responseTest = response
            errorTest = error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
                
        // then
        XCTAssertNil(errorTest)
        XCTAssertEqual(stat, "ok")
        XCTAssertNotNil(responseTest)
    }
    
    func testPresenter() throws {
        viewController.presenter?.searchQuery = "Cat"
        viewController.presenter?.fetchData()
        viewController.presenter?.view = nil
        let promise = expectation(description: "Completion handler invoked")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertGreaterThan(viewController.presenter?.photos.count ?? 0, 1)
    }
    
    func testPresenterFetchDataForInvalidInput() throws {
        viewController.presenter?.searchQuery = "@#$@$@$@$@$&%&$%*$%*^&^%JDFG$@$@$@4"
        viewController.presenter?.fetchData()
        viewController.presenter?.view = nil
        let promise = expectation(description: "Completion handler invoked")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(viewController.presenter?.photos.count ?? 0, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            viewController.presenter?.searchQuery = "Cat"
            viewController.presenter?.fetchData()
            viewController.presenter?.view = nil
        }
    }

}
