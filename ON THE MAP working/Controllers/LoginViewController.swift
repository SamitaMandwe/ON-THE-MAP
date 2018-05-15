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
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    //MARK:  Keyboard Functions for subscribing to keyboard notifications and shifting the view whenever the keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = getKeyboardHeight(notification) * (-0.5)
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if passwordTextfield.isFirstResponder {
            return keyboardSize.cgRectValue.height
        } else {
            return 0
        }
    }
}
