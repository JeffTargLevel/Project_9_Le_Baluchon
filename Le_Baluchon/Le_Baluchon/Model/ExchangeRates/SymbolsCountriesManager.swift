//
//  SymbolsCountriesManager.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 29/01/2019.
//  Copyright © 2019 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class SymbolsCountriesManager {
    
    private static let symbolsCountriesUrl = URL(string: "http://data.fixer.io/api/symbols?access_key=43b3cea4bcddba105c31a55d02fe56f8&format=1")!
    
    private static var task: URLSessionTask?
    
    static var symbolsCountriesSession = URLSession(configuration: .default)
    
    private static func createSymbolsCountriesRequest() -> URLRequest {
        var request = URLRequest(url: SymbolsCountriesManager.symbolsCountriesUrl)
        request.httpMethod = "GET"
        return request
    }
    
    static func getSymbolsCountries(callback: @escaping (Bool, Symbols?) -> Void) {
        let request = createSymbolsCountriesRequest()
        
        task?.cancel()
        task = symbolsCountriesSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(FixerApiResponse.self, from: data), let countries = responseJSON.symbols else {
                    callback(false, nil)
                    return
                }
                let symbols = Symbols(countries: countries)
                callback(true, symbols)
            }
        }
        task?.resume()
    }
}
