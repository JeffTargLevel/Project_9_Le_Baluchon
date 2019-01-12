//
//  YahooWeatherApiResponse.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 13/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct OpenWeatherApiResponse: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let description: String?
}

struct Main: Codable {
    let temp: Double?
}
    

