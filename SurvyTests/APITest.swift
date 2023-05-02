//
//  APITest.swift
//  SurvyTests
//
//  Created by Mac mini on 2023/05/02.
//

import XCTest
import Alamofire

@testable import Survy

final class APITest: XCTestCase {

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

}

extension APITest {
    func test_tags() {
        let expectation = self.expectation(description: "api call testing")
        
        AF.request("https://dearsurvy.herokuapp.com/tags")
            .responseDecodable(of: TagResponse.self) { response in
                do {
                    let resultValue = try response.result.get()
                    print("fetched result: \(resultValue)")
                    
                    XCTAssertNotNil(resultValue)
                    expectation.fulfill()
                } catch let error {
                    print("encountered error \(error.localizedDescription)")
                }
            }
        waitForExpectations(timeout: 10)
    }
}
