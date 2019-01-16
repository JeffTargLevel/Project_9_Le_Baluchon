//
//  FakeResponseWeatherData.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 16/01/2019.
//  Copyright © 2019 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class FakeResponseWeatherData {
    // MARK: - Data
    static var parisWeatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseWeatherData.self)
        let url = bundle.url(forResource: "ParisWeather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var newYorkWeatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseWeatherData.self)
        let url = bundle.url(forResource: "NewYorkWeather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    // MARK: - Error
    class WeatherError: Error {}
    static let error = WeatherError()
}
