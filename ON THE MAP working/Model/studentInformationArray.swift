//
//  studentArray.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 3/1/18.
//  Copyright © 2018 udacity. All rights reserved.
//


import MapKit

// Ckass fir keeping StudentInformation array and annotations
class StudentInformationArray {
    var array: [StudentInformation] = [StudentInformation]()
    var annotations:[MKPointAnnotation] = [MKPointAnnotation]()
    var objectId = String()

    func downloadAndStoreData( completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        ParseClient.sharedInstance().getStudentsLocations() {locations,error in
            guard (error == nil) else {
                completionHandler(false, error)
                return
            }
            guard let locations = locations else {
                completionHandler(false, error)
                print("locationsError")
                return
            }
            self.array = StudentInformation.studentInformationFromResults(locations)
            self.annotations = StudentInformation.annotationsFromStudentInformation(StudentInformationArray.sharedInstance().array)
            completionHandler(true, nil)
        }
    }
    
    // Singleton
    class func sharedInstance() -> StudentInformationArray {
        struct Singleton {
            static var sharedInstance = StudentInformationArray()
        }
        return Singleton.sharedInstance
    }
}
