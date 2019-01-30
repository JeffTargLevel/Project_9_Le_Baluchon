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
    @IBOutlet weak var countryExchangeLabel: UILabel!
    @IBOutlet weak var resultExchangeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countriesRatesPickerView: UIPickerView!
    
    private var symbols = Symbols() {
        didSet {
            countriesRatesPickerView.reloadAllComponents()
        }
    }
    
    private var rates: Rates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        updateSymbols()
        updateRequest()
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}

// MARK: - Picker view setting

extension ExchangeRatesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return symbols.countries.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        updateCountryExchangeLabel()
        let countriesSymbols = [String](symbols.countries.keys)
        if (euroTextField.text?.count)! > 0 {
            update(rates: rates!)
        }
        return countriesSymbols[row]
    }
}

// MARK: - Update request and rates with euro base

extension ExchangeRatesViewController {
    
    private func updateSymbols() {
        toggleActivityIndicator(shown: true)
        SymbolsCountriesManager.getSymbolsCountries { (success, symbols) in
            self.toggleActivityIndicator(shown: false)
            if success, let countriesSymbols = symbols {
                self.symbols = countriesSymbols
            } else {
                self.presentAlert()
            }
        }
    }
    
    private func updateRequest() {
        toggleActivityIndicator(shown: true)
        ExchangeRatesManager.getExchangeRates { (success, rates) in
            self.toggleActivityIndicator(shown: false)
            if success {
                self.rates = rates
            } else {
                self.presentAlert()
            }
        }
    }
    
    private func update(rates: Rates) {
        if (euroTextField.text?.count)! > 0 {
            changeKeyboard()
            let countryIndex = countriesRatesPickerView.selectedRow(inComponent: 0)
            let countriesSymbols = [String](symbols.countries.keys)
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
}

// MARK: - Check if the first character is a number and change keyboard to the decimal point

extension ExchangeRatesViewController {
    
    private func changeKeyboardType(_ keyboardtype: UIKeyboardType) {
        euroTextField.resignFirstResponder()
        euroTextField.keyboardType = keyboardtype
        euroTextField.becomeFirstResponder()
    }
    
    private func changeKeyboard() {
        if (euroTextField.text?.contains("."))! || (euroTextField.text?.isEmpty)! {
            changeKeyboardType(.numberPad)
        } else {
            changeKeyboardType(.decimalPad)
        }
    }
    
    // MARK: - Clear euro text field and result exchange label
    
    private func clearEuroTextFieldAndResultExchangeLabel() {
        euroTextField.text = ""
        resultExchangeLabel.text = ""
        changeKeyboard()
        updateRequest()
    }
    
    private func updateCountryExchangeLabel() {
        let countriesNames = [String](symbols.countries.values)
        let countryIndex = countriesRatesPickerView.selectedRow(inComponent: 0)
        let countryName = countriesNames[countryIndex]
        countryExchangeLabel.text = countryName
    }
    
    // MARK: - Alert view controller an error
    
    private func presentAlert() {
        presentAlert(withTitle: "Error", message: "Exchange failed")
    }
}

// MARK: - Action dissmiss keyboard and tap euro text field

extension ExchangeRatesViewController {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        clearEuroTextFieldAndResultExchangeLabel()
        euroTextField.resignFirstResponder()
        updateCountryExchangeLabel()
    }
    
    @IBAction func tapEuroTextField(_ sender: UITextField, forEvent event: UIEvent) {
        update(rates: rates!)
    }
}
