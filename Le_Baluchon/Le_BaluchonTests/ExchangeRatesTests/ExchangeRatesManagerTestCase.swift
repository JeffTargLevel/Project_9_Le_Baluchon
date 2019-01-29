//
//  Le_BaluchonTests.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 28/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class ExchangeRatesManagerTestCase: XCTestCase {
    
    func testGetRatesShouldPostFailedCallbackIfError() {
        
        ExchangeRatesManager.exchangeRatesSession = URLRatesSessionFake(data: nil, response: nil, error: FakeResponseRatesData.error)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            
            XCTAssertFalse(success)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostFailedCallbackIfNoData() {
        
        ExchangeRatesManager.exchangeRatesSession = URLRatesSessionFake(data: nil, response: nil, error: nil)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            
            XCTAssertFalse(success)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostFailedCallbackIfIncorrectResponse() {
        
        ExchangeRatesManager.exchangeRatesSession = URLRatesSessionFake(data: FakeResponseRatesData.ratesCorrectData, response: FakeResponseRatesData.responseKO, error: nil)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            
            XCTAssertFalse(success)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        
        ExchangeRatesManager.exchangeRatesSession = URLRatesSessionFake(data: FakeResponseRatesData.ratesIncorrectData, response: FakeResponseRatesData.responseOK, error: nil)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            
            XCTAssertFalse(success)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        
        ExchangeRatesManager.exchangeRatesSession = URLRatesSessionFake(data: FakeResponseRatesData.ratesCorrectData, response: FakeResponseRatesData.responseOK, error: nil)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(rates)
            
            let ratesArray = ratesFake
            
            XCTAssertEqual(ratesArray, rates!.ratesCountries)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}

