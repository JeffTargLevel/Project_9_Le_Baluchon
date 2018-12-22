//
//  DeviseViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var euroTextField: UITextField!
    @IBOutlet weak var countryExchangeLabel: UILabel!
    @IBOutlet weak var dollarExchangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countriesRatesPickerView: UIPickerView!
    
    private let countriesSymbols = [String](symbols.keys)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        updateExchangeLabel()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    // MARK: - Picker view setting
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return symbols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesSymbols[row]
    }
    
    // MARK : - Update rates with euro base
    
    private func update(rates: Rates) {
        if (euroTextField.text?.count)! > 0 {
            let countryIndex = countriesRatesPickerView.selectedRow(inComponent: 0)
            let countrySymbol = countriesSymbols[countryIndex]
            
            if let rateValue = rates.ratesCountries[countrySymbol] {
                let euro = Double(euroTextField.text!)
                let resultExchange = euro! * rateValue
                dollarExchangeLabel.text = String(resultExchange)
            }
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
    }
    
    private func updateExchangeLabel() {
        let countriesNames = [String](symbols.values)
        let countryIndex = countriesRatesPickerView.selectedRow(inComponent: 0)
        let countryName = countriesNames[countryIndex]
        countryExchangeLabel.text = countryName
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
        updateExchangeLabel()
    }
    
    @IBAction func tapEuroTextField(_ sender: Any, forEvent event: UIEvent) {
        toggleActivityIndicator(shown: true)
        updateExchangeLabel()
        ExchangeRatesManager.shared.getExchangeRates { (success, rate) in
            self.toggleActivityIndicator(shown: false)
            if success, let rate = rate {
                self.update(rates: rate)
            } else {
                self.presentAlert()
            }
        }
    }
}

