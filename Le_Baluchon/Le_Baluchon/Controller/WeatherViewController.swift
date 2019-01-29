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
    
    private func update(cityConditions: Conditions, cityTemperatureLabel: UILabel, cityConditionsLabel: UILabel) {
        cityTemperatureLabel.text = String(cityConditions.temperature) + " " + "°C"
        cityConditionsLabel.text = cityConditions.currentConditions
    }
    
    // MARK: - Update city request and update city image
    
    private func updateParisRequest() {
        toggleActivityIndicator(shown: true)
        WeatherManager.getCityWeather(with: WeatherManager.parisWeatherUrl) { (success, conditions) in
            self.toggleActivityIndicator(shown: false)
            if success, let conditions = conditions {
                self.update(cityConditions: conditions, cityTemperatureLabel: self.parisTemperatureLabel, cityConditionsLabel: self.parisConditionsLabel)
            } else {
                self.presentAlert()
            }
        }
    }
    
    @objc private func updateNewYorkRequest() {
        toggleActivityIndicator(shown: true)
        WeatherManager.getCityWeather(with: WeatherManager.newYorkWeatherUrl) { (success, conditions) in
            self.toggleActivityIndicator(shown: false)
            if success, let conditions = conditions {
                self.update(cityConditions: conditions, cityTemperatureLabel: self.newYorkTemperatureLabel, cityConditionsLabel: self.newYorkConditionsLabel)
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
