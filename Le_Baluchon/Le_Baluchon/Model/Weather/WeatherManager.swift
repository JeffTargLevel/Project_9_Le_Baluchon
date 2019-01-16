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
    
    private static let parisWeatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&lang=fr&units=metric&")!
    
    private static let newYorkWeatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Manhattan,us&lang=fr&units=metric&")!
    
    private var task: URLSessionTask?
    
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    private func createWeatherRequest(with url: URL) -> URLRequest {
        let request = URLRequest(url: url)
        return request
    }
    
    // MARK: - Get Paris weather
    
    func getParisWeather(callback: @escaping (Bool, Conditions?) -> Void) {
        let request = createWeatherRequest(with: WeatherManager.parisWeatherUrl)
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(OpenWeatherApiResponse.self, from: data), let temperature = responseJSON.main.temp, let currentConditions = responseJSON.weather[0].description else {
                    callback(false, nil)
                    return
                }
                let conditions = Conditions(temperature: temperature, currentConditions: currentConditions)
                print(conditions)
                callback(true, conditions)
            }
        }
        task?.resume()
    }
    
    // MARK: - Get New York weather
    
    func getNewYorkWeather(callback: @escaping (Bool, Conditions?) -> Void) {
        let request = createWeatherRequest(with: WeatherManager.newYorkWeatherUrl)
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(OpenWeatherApiResponse.self, from: data), let temperature = responseJSON.main.temp, let currentConditions = responseJSON.weather[0].description else {
                    callback(false, nil)
                    return
                }
                let conditions = Conditions(temperature: temperature, currentConditions: currentConditions)
                print(conditions)
                callback(true, conditions)
            }
        }
        task?.resume()
    }
}
