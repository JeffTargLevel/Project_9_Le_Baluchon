//
//  TranslateManagerTestCase.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 28/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class TranslateManagerTestCase: XCTestCase {
    func testGetTranslateShouldPostFailedCallbackIfError() {
        
        let translateManager = TranslateManager(
            translateSession: URLTranslateSessionFake(data: nil, response: nil, error: FakeResponseTranslateData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateManager.getTranslate { (success, english) in
            
            XCTAssertFalse(success)
            XCTAssertNil(english)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfNoData() {
        
        let translateManager = TranslateManager(
            translateSession: URLTranslateSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateManager.getTranslate { (success, english) in
            
            XCTAssertFalse(success)
            XCTAssertNil(english)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        
        let translateManager = TranslateManager(
            translateSession: URLTranslateSessionFake(
                data: FakeResponseTranslateData.translateCorrectData,
                response: FakeResponseTranslateData.responseKO,
                error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateManager.getTranslate { (success, english) in
            
            XCTAssertFalse(success)
            XCTAssertNil(english)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostFailedCallbackIfIncorrectData() {
        
        let translateManager = TranslateManager(
            translateSession: URLTranslateSessionFake(
                data: FakeResponseTranslateData.translateIncorrectData,
                response: FakeResponseTranslateData.responseOK,
                error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateManager.getTranslate { (success, english) in
            
            XCTAssertFalse(success)
            XCTAssertNil(english)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        
        let translateManager = TranslateManager(
            translateSession: URLTranslateSessionFake(
                data: FakeResponseTranslateData.translateCorrectData,
                response: FakeResponseTranslateData.responseOK,
                error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateManager.getTranslate { (success, english) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(english)
            
            let translateEnglish = "Hello"
            
            XCTAssertEqual(translateEnglish, english!.english)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
