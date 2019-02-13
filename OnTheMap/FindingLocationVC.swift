//
//  FindingLocationVC.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 08/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class FindingLocationVC: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    
    @IBAction func findBtnPressed(_ sender: Any) {
        guard let location = locationField.text else {
            print("Invalid location")
            return
        }
        guard let link = linkField.text else {
            print("Invalid link")
            return
        }
    
        if !(location.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty && !(link.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty {
        
        } else {
            showAlert(title: "", msg: "Please, enter value.")
        }
        
        
    }
    
    func showAlert(title: String, msg: String) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(controller, animated: true, completion: nil)

    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showInfoPostingVC" {
            if let destination = segue.destination as? InfoPostingVC {
                destination.mapString = locationField.text ?? ""
            }
            
        }
        
    }
 

}
