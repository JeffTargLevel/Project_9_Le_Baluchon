//
//  GoogleTranslateApiData.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 16/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct GoogleTranslateApiResponse: Codable {
    let data: Data
}

struct Data: Codable {
    let translations: [Translations]
}

struct Translations: Codable {
    let translatedText: String?
}

