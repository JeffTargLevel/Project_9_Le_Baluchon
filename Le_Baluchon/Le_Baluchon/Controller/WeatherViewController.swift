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
    @IBOutlet weak var newYorkTemperatureLabel: UILabel!
    @IBOutlet weak var newYorkConditionsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        refreshAnyRequests()
    }
    
    // MARK: - Activity indicator and update city conditions
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func update(parisConditions: Conditions) {
        parisTemperatureLabel.text = String(parisConditions.temperature)
        parisConditionsLabel.text = parisConditions.currentConditions
    }
    
    private func update(newYorkConditions: Conditions) {
        newYorkTemperatureLabel.text = String(newYorkConditions.temperature)
        newYorkConditionsLabel.text = newYorkConditions.currentConditions
    }
    
    // MARK: - Update city request and update city image
    
    private func updateParisRequest() {
        toggleActivityIndicator(shown: true)
        WeatherManager.shared.getParisWeather { (success, conditions) in
            self.toggleActivityIndicator(shown: false)
            if success, let conditions = conditions {
                self.update(parisConditions: conditions)
            } else {
                self.presentAlert()
            }
        }
    }
    
    @objc private func updateNewYorkRequest() {
        toggleActivityIndicator(shown: true)
        WeatherManager.shared.getNewYorkWeather { (success, conditions) in
            self.toggleActivityIndicator(shown: false)
            if success, let conditions = conditions {
                self.update(newYorkConditions: conditions)
            } else {
                self.presentAlert()
            }
        }
    }
    
    // MARK: - Perform New York request, animation images
    
    private func performNewYorkRequest() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateNewYorkRequest), userInfo: nil, repeats: false)
    }
    
    @objc private func activeGestureRecognizer() {
        gestureRecognizer.isEnabled = true
        
    }
    
    private func performGestureRecognizer() {
        gestureRecognizer.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.activeGestureRecognizer), userInfo: nil, repeats: false)
    }
    
    private func imagesAnimated() {
        let parisImage = #imageLiteral(resourceName: "Paris")
        let newYorkImage = #imageLiteral(resourceName: "New_York")
        let imgListArray: [UIImage] = [parisImage, newYorkImage]
        
        cityImageView.animationImages = imgListArray
        cityImageView.animationDuration = 20
        cityImageView.startAnimating()
    }
    
    // MARK: - Refresh any requests and alert controller
    
    private func refreshAnyRequests() {
        performGestureRecognizer()
        updateParisRequest()
        performNewYorkRequest()
        imagesAnimated()
    }
    
    private func presentAlert() {
        presentAlert(withTitle: "Error", message: "Update weather failed")
    }
    
    // MARK: - Tap for update
    
    @IBAction func tapForUpdate(_ sender: UITapGestureRecognizer) {
        refreshAnyRequests()
    }
}

