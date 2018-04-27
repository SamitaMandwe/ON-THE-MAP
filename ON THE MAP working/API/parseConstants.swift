//
//  Constants.swift
//  On The Map -1
//
//  Created by Samita Mandwe on 2/14/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {
        static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let methodForStudentLocationsWithParameters = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let methodForStudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
}
