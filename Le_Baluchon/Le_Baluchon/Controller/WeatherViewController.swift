//
//  WeatherViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var parisTemperatureLabel: UILabel!
    @IBOutlet weak var parisConditionsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func update(conditions: Conditions) {
       parisTemperatureLabel.text = conditions.temperature
        parisConditionsLabel.text = conditions.currentConditions
        
    }
    
    @IBAction func tapForUpdate(_ sender: UITapGestureRecognizer) {
        toggleActivityIndicator(shown: true)
        WeatherManager.shared.getWeather { (success, conditions) in
            self.toggleActivityIndicator(shown: false)
            if success, let conditions = conditions {
                self.update(conditions: conditions)
            } else {
                self.presentAlert()
            }
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Update failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
