//
//  Extensions + ViewController.swift
//  SavePass
//
//  Created by Виталий Охрименко on 14/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertSimple(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func copyTextInTextField(your textField: UITextField) {
        
        let alertController = UIAlertController(title: "Cкопировано", message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alertController.dismiss(animated: true, completion: nil)
        }
        let pasteboard = UIPasteboard.general
        pasteboard.string = textField.text
    }
    
    func switchShowHidePasButton(showHideButton: UIButton, securityTextEntry: UITextField, variable: inout Bool) {
        
        if variable {
            showHideButton.setImage(UIImage(named: "invisible"), for: .normal)
            securityTextEntry.isSecureTextEntry = false
        } else {
            showHideButton.setImage(UIImage(named: "visible"), for: .normal)
            securityTextEntry.isSecureTextEntry = true
        }
        variable.toggle()
    }
}
