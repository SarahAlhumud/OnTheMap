//
//  APIClient.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 04/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

class APIClient: NSObject {
    
    // MARK:- Properties
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK:- GET
    // GETting Student Locations
    func getStudentLocations(completionHandlerForGET: @escaping (_ result: [[String:Any]], _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        var rawJSON:Any!
        
        var request = URLRequest(url: parseURL())
        request.addValue(APIConstants.ParseConstants.ApplicationId, forHTTPHeaderField: APIConstants.ParseParameterKeys.ApplicationId)
        request.addValue(APIConstants.ParseConstants.RESTAPIKey, forHTTPHeaderField: APIConstants.ParseParameterKeys.RESTAPIKey)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET([[:]], NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo as [String : Any]))
            }
            
            guard error != nil else{
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
            guard let results = jsonDic["results"] as? [[String:Any]] else {
                sendError("Could not parse JSON Dictionarys to single dictionary: '\(jsonDic)")
                return
            }
            completionHandlerForGET(results, nil)
            
        }
        task.resume()
        return task
        
    }
    
    //MARK:- POST
    //POSTing a Session
    func postSession(email:String, password:String, completionHandlerForPOST: @escaping (_ result: [String:Any], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var rawJSON:Any!

        var request = URLRequest(url: udacityURL())
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
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
            completionHandlerForPOST(jsonDic, nil)
        }
        
        task.resume()
        return task

    }
    
    //MARK:- DELETE
    //DELETEing a Session
    func deleteSession(completionHandlerForDELETE: @escaping (_ result: [String:Any], _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var rawJSON:Any!
        
        var request = URLRequest(url: udacityURL())
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
    private func parseURL() -> URL {
        
        var components = URLComponents()
        components.scheme = APIConstants.ParseConstants.APIScheme
        components.host = APIConstants.ParseConstants.APIHost
        components.path = APIConstants.ParseConstants.APIPath
        
        return components.url!
    }
    
    //Helper for Creating a Udacity URL
    private func udacityURL() -> URL {
        
        var components = URLComponents()
        components.scheme = APIConstants.UdacityConstants.APIScheme
        components.host = APIConstants.UdacityConstants.APIHost
        components.path = APIConstants.UdacityConstants.APIPath + APIConstants.UdacityMethods.Session
        
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
