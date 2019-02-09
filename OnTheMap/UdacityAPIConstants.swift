//
//  UdacityAPIConstants.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 03/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

// MARK: - UdacityAPIConstants

struct UdacityAPIConstants {
    
    // MARK: Constants
    struct UdacityConstants {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIPath = "/v1"
    }
    
    // MARK: Methods
    struct UdacityMethods {
        static let Session = "/session"
        static let Users = "/users"
    }
    
    // MARK: Udacity JSON Body Keys
    struct UdacityJSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Constants
    struct ParseConstants {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
    }
    
    
    // MARK: Udacity JSON Body Keys
    struct ParseJSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Response Keys
    struct TMDBResponseKeys {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }

}
