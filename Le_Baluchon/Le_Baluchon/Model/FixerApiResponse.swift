//
//  ResponseFixerApi.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 08/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct FixerApiResponse: Decodable {
    
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
    
}
