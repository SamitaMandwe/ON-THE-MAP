//
//  NewPinViewController.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 3/5/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit
import MapKit

class NewPinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    
    //MARK: - Variables
    var lat = CLLocationDegrees()
    var long = CLLocationDegrees()
    var mapString = String()
    var objectId: String? = nil
    var method: String = "POST"
    var annotation: MKAnnotation?
    
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        activityIndicator.isHidden = true
        locationTextField.delegate = self
        findButton.isHidden = false
        submitButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    //MARK: -  TextField Delegate
    // Hide keyboard when return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    //MARK: -  Actions
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        // check if locations textfield isn't empty
        if let locationString = locationTextField.text, locationString != "" {
            // check if URL can be openned
            if let url = URL(string:locationString), UIApplication.shared.canOpenURL(url) {
                // Get first and last names from Udacity
                UdacityClient.sharedInstance().getUserData(accountKey: UdacityClient.sharedInstance().accountKey!) { (firstName,lastName,error) in
                    if let firstName = firstName, let lastName = lastName {
                        //Create a new instance of StudentLocation
                        let me = StudentInformation(lat: self.lat, long: self.long, firstName: firstName, lastName: lastName, mediaURL: locationString, mapString: self.mapString, uniqueKey: UdacityClient.sharedInstance().accountKey!)
                        // Post or Put Student Information
                        ParseClient.sharedInstance().postPutStudentLocation(studentInformation: me, httpMethod: self.method, objectId: self.objectId )  { (success, error) in
                            if success {
                                //Refreshing Data
                                StudentInformationArray.sharedInstance().downloadAndStoreData() { success,error in
                                    DispatchQueue.main.async {
                                        if success {
                                            self.activityIndicator.stopAnimating()
                                            self.dismiss(animated: true, completion: nil)
                                        } else if let error = error  {
                                            self.showAlert(title: "Error with posting", error: error)
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                showAlert(title: "Url can't be open", error: "Enter valid URL")
            }
        } else {
            showAlert(title: "No URL", error: "Enter URL")
        }
    }
    
    
    @IBAction func findButton(_ sender: Any) {
        activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        // Check if location text field isn't empty
        if let locationString = locationTextField.text, locationString != "" {
            mapString = locationString
            // Geocode the location
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationString) { (placemarks, error) in

                if let placemark = placemarks?[0] {
                    // Show annotation from geocode
                    self.lat = (placemark.location?.coordinate.latitude)!
                    self.long = (placemark.location?.coordinate.longitude)!
                    self.mapView.showAnnotations([MKPlacemark(placemark: placemark)], animated: true)
                    // Prepare VC for request of web-site and submitting
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.findButton.isHidden = true
                    self.submitButton.isHidden = false
                    self.label.text = "Enter your LinkedIn account"
                    self.locationTextField.text = ""
                    self.locationTextField.placeholder = "Enter URL"
                    
                    
                } else if error != nil {
                    self.showAlert(title: "Geolocation failed", error: "Enter different location")
                }
            }
        } else {
            showAlert(title: "No location", error: "Enter location")
        }
        
        
    }
}
