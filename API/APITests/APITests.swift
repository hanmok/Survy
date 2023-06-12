//
//  APITests.swift
//  APITests
//
//  Created by Mac mini on 2023/05/26.
//

import XCTest
@testable import API

final class APITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_sth() {
        APIService.shared.fetchTagsMoya { tags in
            XCTAssertNotNil(tags)
            XCTAssertNil(tags)
        }
    }
    
    func test_postTag() { // why is it not working ??
        let expectation = self.expectation(description: "post")
        APIService.shared.requestTag(tagName: "달리기") { result in
            print("myAPIResult: \(result)")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetchSurveys() {
        let expectation = self.expectation(description: "post")
        APIService.shared.getAllSurveys { result in
            print("myAPIResult: \(result)")
            XCTAssertNil(result)
            expectation.fulfill()
        }
        XCTFail("It took too long to get surveys")
        waitForExpectations(timeout: 10)
    }
}
