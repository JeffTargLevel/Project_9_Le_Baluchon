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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func update(translate: Translate) {
        translateEnglishTextView.text = translate.english
        
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Translation failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        //sourceFrenchTextView.resignFirstResponder()
        TranslateManager.shared.getTranslate { (success, english) in
            if success, let english = english {
                self.update(translate: english)
            } else {
                self.presentAlert()
            }
        }
    }
}
