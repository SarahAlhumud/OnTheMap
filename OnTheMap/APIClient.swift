//
//  APIClient.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 04/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit

class APIClient: NSObject {
    
    // MARK:- Properties
    
    // shared session
    var session = URLSession.shared
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK:- GET
    // Parse API
    // GETting Student Locations
    func getStudentLocations(completionHandlerForGET: @escaping (_ result: [[String:Any]], _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        var rawJSON:Any!
        let methodParameters : [String: Any] = [APIConstants.ParseParameterKeys.Limit: APIConstants.ParseParameterValues.Limit100]
        
        var request = URLRequest(url: parseURL(methodParameters))
        request.addValue(APIConstants.ParseConstants.ApplicationId, forHTTPHeaderField: APIConstants.ParseParameterKeys.ApplicationId)
        request.addValue(APIConstants.ParseConstants.RESTAPIKey, forHTTPHeaderField: APIConstants.ParseParameterKeys.RESTAPIKey)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET([[:]], NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            if error != nil { // Handle error...
                sendError("There was an error with your request: \(error?.localizedDescription ?? "")")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            do {
                rawJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch{
                sendError("Could not parse the data as JSON: '\(data)")
                print("Faild serialize data")
            }
            
            guard let jsonDic = rawJSON as? [String:AnyObject] else {
                sendError("Could not parse the data as JSON Dictionarys: '\(String(describing: rawJSON))")
                return
            }
            guard let results = jsonDic[APIConstants.ParseResponseKeys.results] as? [[String:Any]] else {
                sendError("Could not parse JSON Dictionarys to single dictionary: '\(jsonDic)")
                return
            }
            completionHandlerForGET(results, nil)
            
        }
        task.resume()
        return task
        
    }
    
    // Udacity API
    //GETting Public User Data
    func getUserName(completionHandlerForGET: @escaping (_ firstName: String, _ lastName: String, _ nickname: String, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var rawJSON:Any!
        
        var request = URLRequest(url: udacityURL(isSessionmethod: false))
        
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET("", "" ,"" , NSError(domain: "getNickname", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error?.localizedDescription ?? "")")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                rawJSON = try JSONSerialization.jsonObject(with: newData, options: [])
            } catch{
                sendError("Could not parse the data as JSON")
                print("Faild serialize data")
            }
            guard let jsonDic = rawJSON as? [String:AnyObject] else {
                sendError("Could not parse the data as JSON Dictionarys")
                return
            }
            //            guard let user = jsonDic[APIConstants.UdacityResponseKeys.Enrollments] as? [String:Any] else {
            //                sendError("Could not parse User Dictionarys to single dictionary")
            //                return
            //            }
            guard let firstName = jsonDic[APIConstants.UdacityResponseKeys.FirstName] as? String else {
                sendError("Could not parse user Dictionarys to firstName string")
                return
            }
            guard let lastName = jsonDic[APIConstants.UdacityResponseKeys.LastName] as? String else {
                sendError("Could not parse user Dictionarys to lastName string")
                return
            }
            guard let nickName = jsonDic[APIConstants.UdacityResponseKeys.NickName] as? String else {
                sendError("Could not parse user Dictionarys to lastName string")
                return
            }
            
            completionHandlerForGET(firstName, lastName, nickName, nil)
        }
        
        task.resume()
        return task
        
    }
    
    //MARK:- POST
    // Udacity API
    //POSTing a Session
    func postSession(email:String, password:String, completionHandlerForPOST: @escaping (_ result: [String:Any], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var rawJSON:Any!
        
        var request = URLRequest(url: udacityURL(isSessionmethod: true))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string
        request.httpBody = "{\"\(APIConstants.UdacityJSONBodyKeys.Udacity)\": {\"\(APIConstants.UdacityJSONBodyKeys.Username)\": \"\(email)\", \"\(APIConstants.UdacityJSONBodyKeys.Password)\": \"\(password)\"}}".data(using: .utf8)
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST([:], NSError(domain: "postSession", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error?.localizedDescription ?? "")")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if (response as? HTTPURLResponse)?.statusCode ?? 0 >= 400 && (response as? HTTPURLResponse)?.statusCode ?? 0 <= 499 {
                    sendError("Please, enter correct email and password.")
                } else {
                    sendError("Your request returned a status code other than 2xx!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            do {
                rawJSON = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            } catch{
                sendError("Could not parse the data as JSON")
                print("Faild serialize data")
            }
            
            guard let jsonDic = rawJSON as? [String:AnyObject] else {
                sendError("Could not parse the data as JSON Dictionarys")
                return
            }
            self.assignAuthInfo(jsonDic)
            completionHandlerForPOST(jsonDic, nil)
        }
        
        task.resume()
        return task
        
    }
    
    //Assign sessionID and accountID to "AuthInfo" app varaible
    private func assignAuthInfo(_ resultsData: [String : Any]){
        
        guard let session = resultsData[APIConstants.UdacityResponseKeys.Session] as? [String:Any] else {
            print("Could not parse JSON Dictionarys to single dictionary: '\(resultsData)")
            return
        }
        guard let account = resultsData[APIConstants.UdacityResponseKeys.Account] as? [String:Any] else {
            print("Could not parse JSON Dictionarys to single dictionary: '\(resultsData)")
            return
        }
        delegate.sessionID = session[APIConstants.UdacityResponseKeys.SessionID] as? String ?? ""
        delegate.accountID = account[APIConstants.UdacityResponseKeys.AccountID] as? String ?? ""
        
    }
    
    // Parse API
    // POSTing a Student Location
    func postStudentLocation(studentLocation: StudentInformation, completionHandlerForPOST: @escaping (_ resultJSON: Any, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        var rawJSON:Any!
        
        var request = URLRequest(url: parseURL(nil))
        request.httpMethod = "POST"
        request.addValue(APIConstants.ParseConstants.ApplicationId, forHTTPHeaderField: APIConstants.ParseParameterKeys.ApplicationId)
        request.addValue(APIConstants.ParseConstants.RESTAPIKey, forHTTPHeaderField: APIConstants.ParseParameterKeys.RESTAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"firstName\": \"\(studentLocation.firstName ?? "")\", \"lastName\": \"\(studentLocation.lastName ?? "")\",\"mapString\": \"\(studentLocation.mapString ?? "")\", \"mediaURL\": \"\(studentLocation.mediaURL ?? "")\",\"latitude\": \(studentLocation.latitude ?? 90), \"longitude\": \(studentLocation.longitude ?? 180)}".data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST([[:]], NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            if error != nil { // Handle error...
                sendError("There was an error with your request: \(error?.localizedDescription ?? "")")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do {
                rawJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch{
                sendError("Could not parse the data as JSON: '\(data)")
                print("Faild serialize data")
            }
            
            completionHandlerForPOST(rawJSON, nil)
            
        }
        task.resume()
        return task
        
    }
    
    
    //MARK:- DELETE
    // Udacity API
    //DELETEing a Session
    func deleteSession(completionHandlerForDELETE: @escaping (_ result: [String:Any], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var rawJSON:Any!
        
        var request = URLRequest(url: udacityURL(isSessionmethod: true))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE([:], NSError(domain: "postSession", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            guard error == nil else {
                sendError("There was an error with your request: \(error?.localizedDescription ?? "")")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            do {
                rawJSON = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            } catch{
                sendError("Could not parse the data as JSON")
                print("Faild serialize data")
            }
            
            guard let jsonDic = rawJSON as? [String:AnyObject] else {
                sendError("Could not parse the data as JSON Dictionarys")
                return
            }
            completionHandlerForDELETE(jsonDic, nil)
        }
        
        task.resume()
        return task
        
    }
    
    
    
    //Helper for Creating a Parse URL
    private func parseURL(_ parameters: [String: Any]?) -> URL {
        
        var components = URLComponents()
        components.scheme = APIConstants.ParseConstants.APIScheme
        components.host = APIConstants.ParseConstants.APIHost
        components.path = APIConstants.ParseConstants.APIPath
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    //Helper for Creating a Udacity URL
    private func udacityURL(isSessionmethod: Bool) -> URL {
        
        var components = URLComponents()
        components.scheme = APIConstants.UdacityConstants.APIScheme
        components.host = APIConstants.UdacityConstants.APIHost
        components.path = APIConstants.UdacityConstants.APIPath + ((isSessionmethod) ? (APIConstants.UdacityMethods.Session) : (APIConstants.UdacityMethods.Users + APIConstants.UdacityMethods.UserID))
        
        return components.url!
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> APIClient {
        struct Singleton {
            static var sharedInstance = APIClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
