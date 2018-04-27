//
//  ViewControllerExtension.swift
//  On the Map
//
//  Created by mac on 11/20/16.
//  Copyright © 2016 Alder. All rights reserved.
//


import UIKit

extension UIViewController {

    // Show Alert controller with error
    func showAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Hide keyboard when tapped somewhere
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Open URL in Safari
    
    func openURLInSafari(urlString: String) {
        if let URL = URL(string: urlString) {
            //app.openURL(toOpenURL)
            if  UIApplication.shared.canOpenURL(URL) {
                UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            } else {
                showAlert(title: "URL can't be opened", error: "URL provided by student is invalid")
            }
        } else {
            showAlert(title: "URL can't be opened", error: "URL provided by student is invalid")
        }
    }
    
}
