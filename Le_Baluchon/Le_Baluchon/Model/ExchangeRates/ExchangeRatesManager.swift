//
//  ExchangeRatesManager.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 07/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class ExchangeRatesManager {
    
    private static let exchangeRatesApiKey = ExchangeRatesApiKey()
    
    private static let exchangeRatesUrl = URL(string: "http://data.fixer.io/api/latest?\(exchangeRatesApiKey.key)&format=1")!
    
    private static var task: URLSessionTask?
    
    static var exchangeRatesSession = URLSession(configuration: .default)
    
    private static func createExchangeratesRequest() -> URLRequest {
        var request = URLRequest(url: ExchangeRatesManager.exchangeRatesUrl)
        request.httpMethod = "GET"
        return request
    }
    
    static func getExchangeRates(callback: @escaping (Bool, Rates?) -> Void) {
        let request = createExchangeratesRequest()
        
        task?.cancel()
        task = exchangeRatesSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(FixerApiResponse.self, from: data), let ratesCountries = responseJSON.rates else {
                    callback(false, nil)
                    return
                }
                let rates = Rates(ratesCountries: ratesCountries)
                callback(true, rates)
            }
        }
        task?.resume()
    }
}

