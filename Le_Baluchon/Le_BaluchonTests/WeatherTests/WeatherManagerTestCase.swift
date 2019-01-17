//
//  WeatherManagerTestCase.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 28/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class WeatherManagerTestCase: XCTestCase {
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        
        let weatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(data: nil, response: nil, error: FakeResponseWeatherData.error))
        
        let expectation1 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        
        let weatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(data: nil, response: nil, error: nil))
        
        let expectation1 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        
        let parisWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.parisWeatherCorrectData,
                response: FakeResponseWeatherData.responseKO,
                error: nil))
        
        let expectation1 = XCTestExpectation(description: "Wait for queue change.")
        parisWeatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation1.fulfill()
        }
        
        let newYorkWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.newYorkWeatherCorrectData,
                response: FakeResponseWeatherData.responseKO,
                error: nil))
        
        let expectation2 = XCTestExpectation(description: "Wait for queue change.")
        newYorkWeatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        
        let weatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.weatherIncorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        let expectation1 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation1.fulfill()
        }
        
        let expectation2 = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2)
    }
    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        
        let ParisWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.parisWeatherCorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        let expectation1 = XCTestExpectation(description: "Wait for queue change.")
        ParisWeatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(conditions)
            
            let temperature = 1.57
            let currentConditons = "ciel dégagé"
            
            XCTAssertEqual(temperature, conditions?.temperature)
            XCTAssertEqual(currentConditons, conditions?.currentConditions)
            expectation1.fulfill()
        }
        
        let newYorkWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.newYorkWeatherCorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        let expectation2 = XCTestExpectation(description: "Wait for queue change.")
        newYorkWeatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(conditions)
            
            let temperature = -1.05
            let currentConditons = "brume"
            
            XCTAssertEqual(temperature, conditions?.temperature)
            XCTAssertEqual(currentConditons, conditions?.currentConditions)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2)
    }
}
