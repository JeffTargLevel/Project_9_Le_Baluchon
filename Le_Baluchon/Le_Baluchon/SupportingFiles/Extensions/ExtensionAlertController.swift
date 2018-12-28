//
//  ExtensionAlertController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 27/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
