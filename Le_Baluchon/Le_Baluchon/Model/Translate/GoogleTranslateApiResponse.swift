//
//  GoogleTranslateApiResponse.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 11/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct GoogleTranslateApiResponse: Codable {
    var translations: [String: String]
    
}
