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

    // Genres
    func test_AllGenres() {
        let expectation = self.expectation(description: "get all posts")
//        APIService.shared.fetchGenres { genres in
        APIService.shared.getAllGenres { genres in
            print("fetched Genres: \(genres)")
            XCTAssertNotNil(genres)
//            XCTAssertNil(genres)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_fetchSurveys() {
        let expectation = self.expectation(description: "get all surveys")
        APIService.shared.getAllSurveys { result in
            print("myAPIResult: \(result)")
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_fetchSurveyGenres() {
        let expectation = self.expectation(description: "get all survey_genres")
        
        APIService.shared.getAllSurveyGenres { surveyGenres in
            print("myAPIResult: \(surveyGenres)")
            XCTAssertNotNil(surveyGenres)
            XCTAssertNil(surveyGenres)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
    func test_fetchUserPostedSurveys() {
        
    }
    
    // MARK: - Posting
    func test_postSurvey() {
        let expectation = self.expectation(description: "post Survey")
        let (title, participationGoal, userId) = ("something", 100, 4)
        
        APIService.shared.postSurvey(title: title, participationGoal: participationGoal, userId: userId) { id, string  in
            guard let id = id else { fatalError() }
            print("id: \(id), string: \(string)")
            
            // TODO: Make Section
            XCTAssertNotNil(id)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
    func test_postSection() {
        let expectation = self.expectation(description: "post section")
        let (title, sequence, surveyId) = ("sectionTitle", 2, 4)
        APIService.shared.postSection(title: title, sequence: sequence, surveyId: surveyId) { id, string in
            guard let id = id else { fatalError() }
            print("id: \(id), string: \(string)")
            XCTAssertNotNil(id)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_fetchSections() {
        let expectation = self.expectation(description: "get all sections")
        APIService.shared.getSections { sections, message  in
            print("myAPIResult: \(sections)")
            XCTAssertNotNil(sections)
            XCTAssertNil(sections)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    
    func test_postQuestion() {
        let expectation = self.expectation(description: "post question")
        let (text, sectionId, questionTypeId, expectedTimeInSec) = ("Test Question Text", 34, 4, 20)
        
        APIService.shared.postQuestion(text: text, sectionId: sectionId, questionTypeId: questionTypeId, expectedTimeInSec: expectedTimeInSec) { questionId, string in
            
            guard let questionId = questionId else { fatalError() }
            print("questionId: \(questionId), string: \(string)")
            
            XCTAssertNotNil(questionId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    func test_postSelectableOption() {
        let expectation = self.expectation(description: "post selectableOption")
        let (value, position, questionId) = ("test selectableOption", 0, 4)
        
        APIService.shared.postSelectableOption(value: value, position: position, questionId: questionId) { result, string in
            guard let result = result else { fatalError() }
            XCTAssertNotNil(result)
            print("result string: \(string)")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_connectSurveyToGenres() {
        let expectation = self.expectation(description: "post survey_genre")
        let (surveyId, genreId) = (4, 4)
        
        APIService.shared.connectSurveyGenres(surveyId: surveyId, genreId: genreId) { result, message in
            guard let result = result else { fatalError() }
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    // Done
    func test_connectUserToSurveys() {
        let expectation = self.expectation(description: "post user_survey")
        let (surveyId, userId) = (4, 4)
        APIService.shared.postSurveyUser(userId: userId, surveyId: surveyId) { result, message in
            guard let result = result else { fatalError() }
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
