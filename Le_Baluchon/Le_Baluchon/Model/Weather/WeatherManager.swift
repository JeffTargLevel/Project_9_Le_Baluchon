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
    
    private static let parisWeatherUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%20615702&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
    
    private static let newYorkWeatherUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202459115&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!
    
    private var task: URLSessionTask?
    
    private var parisWeatherSession = URLSession(configuration: .default)
    private var newYorkWeatherSession = URLSession(configuration: .default)
    
    init(parisWeatherSession: URLSession, newYorkWeatherSession: URLSession) {
        self.parisWeatherSession = parisWeatherSession
        self.newYorkWeatherSession = newYorkWeatherSession
    }
    
    private func createWeatherRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    // MARK: - Get Paris Weather
    
    func getParisWeather(callback: @escaping (Bool, ParisConditions?) -> Void) {
        let request = createWeatherRequest(with: WeatherManager.parisWeatherUrl)
        
        task?.cancel()
        task = parisWeatherSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(YahooWeatherApiResponse.self, from: data), let temperature = responseJSON.query.results.channel.item.condition.temp, let currentCondition = responseJSON.query.results.channel.item.condition.text else {
                    callback(false, nil)
                    return
                }
                let conditions = ParisConditions(temperature: temperature, currentConditions: currentCondition)
                print(conditions)
                callback(true, conditions)
            }
        }
        task?.resume()
    }
    
    // MARK: - Get New York weather
    
    func getNewYorkWeather(callback: @escaping (Bool, NewYorkConditions?) -> Void) {
        let request = createWeatherRequest(with: WeatherManager.newYorkWeatherUrl)
        
        task?.cancel()
        task = newYorkWeatherSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(YahooWeatherApiResponse.self, from: data), let temperature = responseJSON.query.results.channel.item.condition.temp, let currentCondition = responseJSON.query.results.channel.item.condition.text else {
                    callback(false, nil)
                    return
                }
                let conditions = NewYorkConditions(temperature: temperature, currentConditions: currentCondition)
                print(conditions)
                callback(true, conditions)
            }
        }
        task?.resume()
    }
}

