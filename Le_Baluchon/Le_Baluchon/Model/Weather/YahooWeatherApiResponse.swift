//
//  YahooWeatherApiResponse.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 13/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct YahooWeatherApiResponse: Codable {
    var temperature: [String: String]
    var currentConditions: [String: String]
}
