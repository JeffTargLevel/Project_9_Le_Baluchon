//
//  FakeResponseRatesData.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 28/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class FakeResponseRatesData {
    // MARK: - Data
    static var ratesCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseRatesData.self)
        let url = bundle.url(forResource: "ExchangeRates", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let ratesIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    // MARK: - Error
    class RatesError: Error {}
    static let error = RatesError()
}
