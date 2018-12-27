//
//  TranslateViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var sourceFrenchTextView: UITextView!
    @IBOutlet weak var translateEnglishTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }
    
    // MARK: - Activity indicator management
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    // MARK: - Update request
    
    private func updateRequest() {
        TranslateManager.shared.getTranslate { (success, english) in
            self.toggleActivityIndicator(shown: false)
            if success, let english = english {
                self.update(translate: english)
            } else {
                self.presentAlert()
            }
        }
    }
    
    // MARK: - Update french and translation english text view
    
    private func updateFrenchText() {
        TranslateManager.shared.originalLanguage.french = sourceFrenchTextView.text
        countryImageView.image = #imageLiteral(resourceName: "usa-flag-std_1")
    }
    
    private func update(translate: Translate) {
        translateEnglishTextView.text = translate.english
    }
    
    // MARK: - Set return keyboard
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            toggleActivityIndicator(shown: true)
            updateFrenchText()
            updateRequest()
        } else if sourceFrenchTextView.text.count <= 1 {
            translateEnglishTextView.text = ""
            countryImageView.image = #imageLiteral(resourceName: "france-flag-std")
        }
        return true
    }
    
    // MARK: - Alert controller
    
    private func presentAlert() {
        presentAlert(withTitle: "Error", message: "Translation failed")
    }
    
    // MARK: - Dissmiss keyboard action and clear text view
    
    @IBAction func dissmissKeyboardAndClearTextView(_ sender: UITapGestureRecognizer) {
        sourceFrenchTextView.resignFirstResponder()
        sourceFrenchTextView.text = ""
        translateEnglishTextView.text = ""
        countryImageView.image = #imageLiteral(resourceName: "france-flag-std")
    }
}
