//
//  YahooWeatherApiResponse.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 13/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct YahooWeatherApiResponse: Codable {
    let query: Query
}

struct Query: Codable {
    let results: Results
}

struct Results: Codable {
    let channel: Channel
}

struct Channel: Codable {
    let item: Item
    
}

struct Item: Codable {
    let condition: Condition
}

struct Condition: Codable {
    let temp:String?
    let text: String?
}




    
    
    
    

