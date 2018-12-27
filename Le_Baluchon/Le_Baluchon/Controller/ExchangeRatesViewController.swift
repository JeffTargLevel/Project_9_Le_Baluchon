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
    @IBOutlet weak var resultExchangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countriesRatesPickerView: UIPickerView!
    
    private let countriesSymbols = [String](symbols.keys)
    private var rate: Rates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        updateRequest()
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
        updateCountryExchangeLabel()
        if (euroTextField.text?.count)! > 0 {
        update(rates: rate!)
        }
        return countriesSymbols[row]
    }
    
    // MARK : - Update request and rates with euro base
    
    private func updateRequest() {
        toggleActivityIndicator(shown: true)
        ExchangeRatesManager.shared.getExchangeRates { (success, rate) in
            self.toggleActivityIndicator(shown: false)
            if success {
               self.rate = rate
            } else {
                self.presentAlert()
            }
        }
    }
    
    private func update(rates: Rates) {
        if (euroTextField.text?.count)! > 0 {
            let countryIndex = countriesRatesPickerView.selectedRow(inComponent: 0)
            let countrySymbol = countriesSymbols[countryIndex]
            
            if let rateValue = rates.ratesCountries[countrySymbol] {
                let euro = Double(euroTextField.text!)
                let resultExchange = euro! * rateValue
                resultExchangeLabel.text = String(resultExchange)
            }
        } else if euroTextField.text?.count == 0 {
            clearEuroTextFieldAndResultExchangeLabel()
        } else {
            presentAlert()
        }
    }
    
    // MARK: - Clear euro text field and result exchange label
    
    private func clearEuroTextFieldAndResultExchangeLabel() {
        euroTextField.text = ""
        resultExchangeLabel.text = ""
        updateRequest()
    }
    
    private func updateCountryExchangeLabel() {
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
        clearEuroTextFieldAndResultExchangeLabel()
        updateCountryExchangeLabel()
    }
    
    @IBAction func tapEuroTextField(_ sender: UITextField, forEvent event: UIEvent) {
        update(rates: rate!)
    }
}
