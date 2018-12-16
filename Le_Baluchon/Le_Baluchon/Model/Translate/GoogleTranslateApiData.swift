//
//  GoogleTranslateApiData.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 16/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation

struct GoogleTranslateApiData: Codable {
    var translations: [[String: String]]
    var translation: String? {
        for _translate in translations {
            if _translate["model"] == "base" {
                return _translate["translatedText"]
            }
        }
        return nil
    }
}
