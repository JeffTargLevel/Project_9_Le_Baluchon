//
//  DeviseViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    
    @IBOutlet weak var euroTextField: UITextField!
    @IBOutlet weak var dollarExchangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
// MARK : - Update rates with euro base
    
    private func update(rates: Rates) {
        if (euroTextField.text?.count)! > 0 {
            countryImageView.image = #imageLiteral(resourceName: "usa-flag-std_1")
            let euro = Double(euroTextField.text!)
            let usd = rates.usd
            let resultExchange = euro! * usd
            dollarExchangeLabel.text = String(resultExchange)
        } else if euroTextField.text?.count == 0 {
            clearEuroTextFieldAndDollarExchangeLabel()
        } else {
            presentAlert()
        }
    }
    
// MARK: - Clear method euro text field ans dollar label
    
    private func clearEuroTextFieldAndDollarExchangeLabel() {
        euroTextField.text = ""
        dollarExchangeLabel.text = ""
        countryImageView.image = #imageLiteral(resourceName: "european-union-flag-std")
    }
    
// MARK: - Alert view controller an error
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Exchange failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
// MARK: - Action dissmiss keyboard and tap euro text field
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        euroTextField.resignFirstResponder()
        clearEuroTextFieldAndDollarExchangeLabel()
    }
    
    @IBAction func tapEuroTextField(_ sender: Any, forEvent event: UIEvent) {
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
}
