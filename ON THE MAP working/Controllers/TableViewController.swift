//
//  TableViewController.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 3/5/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var studentsTableView: UITableView!
    
    var students = [StudentInformation]()
    
    
    
    // MARK: - lifetime
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        students = StudentInformationArray.sharedInstance().array
        studentsTableView.reloadData()
    }
    
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell?.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell?.imageView!.image = #imageLiteral(resourceName: "Pin")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        openURLInSafari(urlString: student.mediaURL)
        
    }
    
    
    
    
    
    
    // MARK: - Actions
    // Adding pin button
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
    }
    
    // Refreshing data and table view
    @IBAction func refreshButton(_ sender: Any) {
        StudentInformationArray.sharedInstance().downloadAndStoreData() {success,error in
            DispatchQueue.main.async {
            
                if success {
                    self.studentsTableView.reloadData()
                } else if let error = error  {
                    self.showAlert(title: "Download failure", error: error)
                }
            }
        }
        
        
    }
    
    
    
    
}


