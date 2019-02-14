//
//  APIConstants.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 03/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

// MARK: - APIConstants

struct APIConstants {
    
    // MARK: Constants
    struct UdacityConstants {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIPath = "/v1"
        static let SignupURL = "https://auth.udacity.com/sign-up"
    }
    
    // MARK: Methods
    struct UdacityMethods {
        static let Session = "/session"
        static let Users = "/users"
        static var UserID: String {
            if let accountID = (UIApplication.shared.delegate as! AppDelegate).accountID {
                return "/" + accountID
            } else {
                return ""
            }
        }
    }
    
    // MARK: Udacity JSON Body Keys
    struct UdacityJSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityResponseKeys {
        static let Session: String = "session"
        static let Account: String = "account"
        static let SessionID: String = "id"
        static let AccountID: String = "key"
        static let User: String = "user"
        static let Enrollments: String = "_enrollments"
        static let FirstName: String = "first_name"
        static let LastName: String = "last_name"
        static let NickName: String = "nickname"
    }
    
    // MARK: Parse Constants
    struct ParseConstants {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: Parse Parameter Keys
    struct ParseParameterKeys {
        static let ApplicationId = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
        static let Limit = "limit"
    }
    
    // MARK: Parse Parameter Values
    struct ParseParameterValues {
        static let Limit100 = 100
        
    }
    
    // MARK: Parse JSON Body Keys
    struct ParseJSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Parse Response Keys
    struct ParseResponseKeys {
        static let results: String = "results"
        static let objectId: String = "objectId"
        static let uniqueKey: String = "uniqueKey"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
    }

}
