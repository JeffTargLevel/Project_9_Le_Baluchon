//
//  TranslateManager.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 11/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class TranslateManager {
    
    private static let translateApiKey = TranslateApiKey()
    
    private static let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?target=en&format=text&source=fr&model=base&\(translateApiKey.key)")!
    
    private static var task: URLSessionTask?
    
    static var translateSession = URLSession(configuration: .default)
    
    static var originalLanguage = OriginalLanguage()
    
    private static func createTranslateRequest() -> URLRequest {
        var request = URLRequest(url: TranslateManager.translateUrl)
        request.httpMethod = "POST"
        let body = "q=\(originalLanguage.french)"
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    static func getTranslate(callback: @escaping (Bool, Translate?) -> Void) {
        let request = createTranslateRequest()
        
        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GoogleTranslateApiResponse.self, from: data), let english = responseJSON.data.translations[0].translatedText else {
                    callback(false, nil)
                    return
                }
                let translation = Translate(english: english)
                callback(true, translation)
            }
        }
        task?.resume()
    }
}

