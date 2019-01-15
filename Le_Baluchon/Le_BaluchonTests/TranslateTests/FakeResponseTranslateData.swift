//
//  FakeResponseTranslateData.swift
//  Le_BaluchonTests
//
//  Created by Jean-François Santolaria on 15/01/2019.
//  Copyright © 2019 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class FakeResponseTranslateData {
    // MARK: - Data
    static var translateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseTranslateData.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let translateIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    // MARK: - Error
    class TranslateError: Error {}
    static let error = TranslateError()
}
