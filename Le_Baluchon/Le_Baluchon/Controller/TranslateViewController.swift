//
//  TranslateViewController.swift
//  Le_Baluchon
//
//  Created by Jean-François Santolaria on 05/12/2018.
//  Copyright © 2018 OpenClassroomsFRSantolariaJF. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var sourceFrenchTextView: UITextView!
    @IBOutlet weak var translateEnglishTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }
    
    // MARK: - Activity indicator and translate button management
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func toggleTranslateButton(shown: Bool) {
        translateButton.isHidden = !shown
    }
    
    // MARK: - Update french and translation english text view
    
    private func updateFrenchText() {
        TranslateManager.shared.french = sourceFrenchTextView.text
    }
    
    private func update(translate: Translate) {
        translateEnglishTextView.text = translate.english
    }
    
    // MARK: - Alert controller
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Translation failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Translate button and dissmiss keyboard action
    
    @IBAction func tapTranslateButton(_ sender: UIButton) {
        toggleTranslateButton(shown: false)
        toggleActivityIndicator(shown: true)
        sourceFrenchTextView.resignFirstResponder()
        updateFrenchText()
        countryImageView.image = #imageLiteral(resourceName: "usa-flag-std_1")
        TranslateManager.shared.getTranslate { (success, english) in
            self.toggleActivityIndicator(shown: false)
            self.toggleTranslateButton(shown: true)
            if success, let english = english {
                self.update(translate: english)
            } else {
                self.presentAlert()
            }
        }
    }
    
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceFrenchTextView.resignFirstResponder()
        if sourceFrenchTextView.text.count == 0 {
            translateEnglishTextView.text = ""
            countryImageView.image = #imageLiteral(resourceName: "france-flag-std")
        }
    }
}

