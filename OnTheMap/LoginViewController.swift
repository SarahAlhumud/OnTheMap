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
            let _ = APIClient.sharedInstance().postSession(email: email, password: password, completionHandlerForPOST: { (resultsData, error) in
                if let error = error {
                    let controller = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(controller, animated: true, completion: nil)
                }
                self.completeLogin()
            })
            
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
        guard let signupURL = URL(string: APIConstants.UdacityConstants.SignupURL) else { return }
        UIApplication.shared.open(signupURL)
    }
    
    //MARK: UITextFieldDelegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMsg.text = ""
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
