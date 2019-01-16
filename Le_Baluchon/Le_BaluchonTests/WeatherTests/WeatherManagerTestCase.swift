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
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
        }
        
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        
        let weatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
        }
        
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        
        let parisWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.parisWeatherCorrectData,
                response: FakeResponseWeatherData.responseKO,
                error: nil))
        
        parisWeatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
        }
        
        let newYorkWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.newYorkWeatherCorrectData,
                response: FakeResponseWeatherData.responseKO,
                error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        newYorkWeatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        
        let weatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.weatherIncorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
        }
        
        weatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertFalse(success)
            XCTAssertNil(conditions)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        
        let ParisWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.parisWeatherCorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        ParisWeatherManager.getParisWeather { (success, conditions) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(conditions)
            
            let temperature = 1.57
            let currentConditons = "ciel dégagé"
            
            XCTAssertEqual(temperature, conditions?.temperature)
            XCTAssertEqual(currentConditons, conditions?.currentConditions)
        }
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let newYorkWeatherManager = WeatherManager(
            weatherSession: URLWeatherSessionFake(
                data: FakeResponseWeatherData.newYorkWeatherCorrectData,
                response: FakeResponseWeatherData.responseOK,
                error: nil))
        
        newYorkWeatherManager.getNewYorkWeather { (success, conditions) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(conditions)
            
            let temperature = -1.05
            let currentConditons = "brume"
            
            XCTAssertEqual(temperature, conditions?.temperature)
            XCTAssertEqual(currentConditons, conditions?.currentConditions)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
