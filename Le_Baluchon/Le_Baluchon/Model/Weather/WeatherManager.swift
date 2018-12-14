//
//  WeatherManager.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 13/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

class WeatherManager {
    static var shared = WeatherManager()
    private init() {}
    
    private static let weatherUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202459115&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
    
    private var task: URLSessionTask?
    
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    private func createWeatherRequest() -> URLRequest {
        var request = URLRequest(url: WeatherManager.weatherUrl)
        request.httpMethod = "GET"
        return request 
    }
    
    func getWeather(callback: @escaping (Bool, Conditions?) -> Void) {
        let request = createWeatherRequest()
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
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
                guard let responseJSON = try? JSONDecoder().decode(YahooWeatherApiResponse.self, from: data), let temperature = responseJSON.temperature["temp"], let currentConditions = responseJSON.currentConditions["text"] else {
                    callback(false, nil)
                    return
                }
                let conditions = Conditions(temperature: temperature, currentConditions: currentConditions)
                callback(true, conditions)
                print(conditions)
            }
        }
        task?.resume()
    }
    
    
    
    
}
