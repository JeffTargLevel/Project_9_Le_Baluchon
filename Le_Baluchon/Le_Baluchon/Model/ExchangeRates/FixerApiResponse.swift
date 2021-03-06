//
//  ResponseFixerApi.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 08/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct FixerApiResponse: Codable {
    let rates: [String: Double]?
    let symbols: [String: String]?
}
