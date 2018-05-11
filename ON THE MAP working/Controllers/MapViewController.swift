//
//  MapViewController.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 3/5/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate = self // MKMapViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh annotations
        mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(StudentInformationArray.sharedInstance().annotations)
    }
    
    // MARK: - MKMapViewDelegate
    // Here we create a view with a "right callout accessory view".
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openURLInSafari(urlString: toOpen)
            }
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession{ (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true)
                } else if let error = error  {
                    self.showAlert(title: "Logout failure", error: error)
                }
            }
        }
        
    }
    

    // MARK: - Actions
    // Add new Pin to the Map
    @IBAction func addPin(_ sender: Any) {
        // Check if your pin exists and show alert
        let students = StudentInformationArray.sharedInstance().array
        for student in students {
            if student.uniqueKey == UdacityClient.sharedInstance().accountKey! {
                
                let alert = UIAlertController(title: "Pin already exists", message: "Do you want to update information?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "NewPinViewController") as! NewPinViewController
                    controller.objectId = student.objectId! // save objectId
                    controller.method = "PUT" // choose method for http task
                    self.present(controller, animated: true, completion: nil) // present NewPinViewController
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Canceled")
                }))
                
                present(alert, animated: true, completion: nil) // present Alert
            }
            
        }
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "NewPinViewController") as! NewPinViewController
        self.present(controller, animated: true, completion: nil) // present NewPinViewController
        
    }
    
    // Refreshing data and annotations
    @IBAction func refreshButton(_ sender: Any) {
        mapView.removeAnnotations(self.mapView.annotations)
        StudentInformationArray.sharedInstance().downloadAndStoreData() {success,error in
            DispatchQueue.main.async {
                if success {
                    self.mapView.addAnnotations(StudentInformationArray.sharedInstance().annotations)
                    
                } else if let error = error  {
                    self.showAlert(title: "Download failure", error: error)
                }
            }
        }
    }
    
    
    
}
