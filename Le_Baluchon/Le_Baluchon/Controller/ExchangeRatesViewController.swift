//
//  DeviseViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    
    @IBOutlet weak var euroExchangeRatesTextField: UITextField!
    @IBOutlet weak var dollarExchangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        euroExchangeRatesTextField.resignFirstResponder()
        toggleActivityIndicator(shown: true)
        
        
        
        ExchangeRatesManager.shared.getExchangeRates { (success, usd) in
            self.toggleActivityIndicator(shown: false)
            if success, let usd = usd {
                self.update(rates: usd)
            } else {
                self.presentAlert()
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func update(rates: Rates) {
        dollarExchangeLabel.text = String(rates.usd)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "exchange failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

