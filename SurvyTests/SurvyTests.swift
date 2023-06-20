//
//  SurvyTests.swift
//  SurvyTests
//
//  Created by Mac mini on 2023/03/31.
//

import XCTest

@testable import Survy

final class SurvyTests: XCTestCase {

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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_number_formatter() {
        let collectedMoney = 56000
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = numberFormatter.string(from: collectedMoney as NSNumber)
        XCTAssertEqual(text, "56,000")
    }
    
    func test_separation() {
        let rewardRange1 = "0"
        let rewardRange2 = "100"
        let rewardRange3 = "100, 200"
        
        XCTAssertEqual(separateRange(rewardRange1), "Free")
        XCTAssertEqual(separateRange(rewardRange2), "100")
        XCTAssertEqual(separateRange(rewardRange3), "100 ~ 200")
    }
    
    func separateRange(_ range: String) -> String {
        
        let components = range.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        guard components.count <= 2 else { fatalError() }
                
        switch components.count {
            case 1:
                if components[0] == "0" { return "Free" }
                return String(components[0])
            case 2:
                return "\(components[0]) ~ \(components[1])"
            default:
                fatalError()
        }
    }
    
    func test_sth() {
        let nums2 = 5 ..< 10
        for num2 in nums2 {
            print("currentNum 1: \(num2)")
            if num2 == 7 { return }
            print("currentNum 2: \(num2)")
        }
    }
}

