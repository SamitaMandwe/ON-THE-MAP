//
//  LoginViewController.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 1/24/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
// MARK: - Lifecycle

override func viewDidLoad() {
super.viewDidLoad()
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribedToKeyboardNotifications(true)
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    subscribedToKeyboardNotifications(false)
}

@IBAction func loginButton(_ sender: UIButton) {
    loginWithUdacity()
}
@IBAction func signUpButton(_ sender: AnyObject) {
    // Open Udacity sign-up page
    UIApplication.shared.open(URL(string: UdacityClient.Constants.signUpURL)!, options: [:], completionHandler: nil)
}
    
    func completeLogin(completionHandler: @escaping () -> Void) {
        // Download Students Locations
        StudentInformationArray.sharedInstance().downloadAndStoreData() {success,error in
            DispatchQueue.main.async {
                if success {
                    // Present tab-bar view controller if success
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(controller, animated: true) {
                        completionHandler()
                    }
                } else if let error = error  {
                    // Show alert if error
                    self.showAlert(title: "Download failed", error: error)
                    completionHandler()
                }
            }
        }
    }
    
func loginWithUdacity() {
    // Posting sesion for Udacity with function postSessionWith()
    UdacityClient.sharedInstance().postSessionWith(email: emailTextField.text!, password: passwordTextfield.text!) { (success, error) in
        // Dispatch UI changes on main queue
        DispatchQueue.main.async {
            if success {
                // Completing login with completeLogin()
                self.completeLogin() {
                    
                }
            } else if let error = error {
                // Show Alert Controller if error not nil
       self.showAlert(title: "login failed", error: error)
            }
        }
    }
}
// MARK: - Keyboard & Notifications setting
// Hide keyboard when return pressed
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}
// Move view up, so both textviews and loginButton are visible
    @objc func keyboardWillShow(_ notification: Notification) {
    view.frame.origin.y = (getKeyboardHeight(notification: notification) - (view.frame.height - loginbutton.frame.maxY) ) * -1
}
// Move view back
    @objc func keyboardWillHide(_ notification:Notification) {
    view.frame.origin.y = 0
}

func getKeyboardHeight(notification: Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
}

// Adding or removing observers for keyboard notifications
func subscribedToKeyboardNotifications(_ state: Bool) {
    if state {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)) , name: .UIKeyboardWillHide, object: nil)
    } else {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
}
