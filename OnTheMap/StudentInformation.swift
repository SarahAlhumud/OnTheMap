//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 04/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

//MARK: StudentInformation
struct StudentInformation {
    
    //MARK: Properties
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:Any]) {
        objectId = dictionary[APIConstants.ParseResponseKeys.objectId] as? String ?? ""
        uniqueKey = dictionary[APIConstants.ParseResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[APIConstants.ParseResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[APIConstants.ParseResponseKeys.lastName] as? String ?? ""
        mediaURL = dictionary[APIConstants.ParseResponseKeys.mediaURL] as? String ?? ""
        mapString = dictionary[APIConstants.ParseResponseKeys.mapString] as? String ?? ""
        latitude = dictionary[APIConstants.ParseResponseKeys.latitude] as? Double ?? 90
        longitude = dictionary[APIConstants.ParseResponseKeys.longitude] as? Double ?? 180
        
    }
    
    init(id: String, key: String, first: String, last: String, map: String, url: String, lat: Double, long: Double) {
        objectId = id
        uniqueKey = key
        firstName = first
        lastName = last
        mapString = map
        mediaURL = url
        latitude = lat
        longitude = long
    }
    
    static func getStudentLocationsFromResults(_ results: [[String:Any]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            studentLocations.append(StudentInformation(dictionary: result))
        }
        
        return studentLocations
    }
}


