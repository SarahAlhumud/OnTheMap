//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 02/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailField.text else {
            print("Invalid email")
            return
        }
        guard let password = passwordField.text else {
            print("Invalid password")
            return
        }
        
        if !(email.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty && !(password.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty {
            setUIEnabled(false)
            postSession(email: email, password: password)
            
        } else {
            errorMsg.text = "Please, enter value."
        }
        
    
    }
    
    
    func setUIEnabled(_ enabled: Bool) {
        emailField.isEnabled = enabled
        passwordField.isEnabled = enabled
        loginBtn.isEnabled = enabled
        errorMsg.text = ""
        errorMsg.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginBtn.alpha = 1.0
        } else {
            loginBtn.alpha = 0.5
        }
    }
    
    // if an error occurs, print it and re-enable the UI
    func displayError(_ error: String, errorMsg: String? = nil) {
        print(error)
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            self.errorMsg.text = errorMsg
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        guard let signupURL = URL(string: "https://auth.udacity.com/sign-up") else { return }
        UIApplication.shared.open(signupURL)
    }
    
    //MARK: UITextFieldDelegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMsg.text = ""
    }
    
    //MARK: UdacityAPI funs
    
    //Helper for Creating a URL
    private func udacityURL() -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityAPIConstants.UdacityConstants.APIScheme
        components.host = UdacityAPIConstants.UdacityConstants.APIHost
        components.path = UdacityAPIConstants.UdacityConstants.APIPath + UdacityAPIConstants.UdacityMethods.Session
        
        return components.url!
    }
    
    //POSTing a Session
    private func postSession(email:String, password:String){
        var request = URLRequest(url: udacityURL())
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"\(UdacityAPIConstants.UdacityJSONBodyKeys.Udacity)\": {\"\(UdacityAPIConstants.UdacityJSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityAPIConstants.UdacityJSONBodyKeys.Password)\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error { // Handle error…
                self.displayError("There was an error with your request: \(error)")
                let controller = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.displayError("Your request returned a status code other than 2xx!")
                
                //Show Alert Msg
                let controller = UIAlertController(title: "Incorrect Email or Password", message: "Please, enter correct email and password.", preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let _ = data else {
                self.displayError("No data was returned by the request!")
                return
            }
            
            self.completeLogin()
            
            
        }
        
        task.resume()
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.errorMsg.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
