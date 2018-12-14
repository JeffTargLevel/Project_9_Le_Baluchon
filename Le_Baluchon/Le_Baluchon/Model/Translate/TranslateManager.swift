//
//  TranslateManager.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 11/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class TranslateManager {
    static var shared = TranslateManager()
    private init() {}

    private static let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?q=bonjour&target=en&format=text&source=fr&model=base&key=AIzaSyBsN1G7xicZttIlt0y8sTmJQ0suwmT1fSU")!
    
    private var task: URLSessionTask?
    
    private var translateSession = URLSession(configuration: .default)
    
    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }
    
    private func createTranslateRequest() -> URLRequest {
        var request = URLRequest(url: TranslateManager.translateUrl)
        request.httpMethod = "POST"
        return request
    }
    
    func getTranslate(callback: @escaping (Bool, Translate?) -> Void) {
        let request = createTranslateRequest()
        
        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                print(String(data: data, encoding: .utf8))
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GoogleTranslateApiResponse.self, from: data), let english = responseJSON.translations["translatedText"] else {
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

