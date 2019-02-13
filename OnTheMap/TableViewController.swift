//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 02/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dictionarys:[StudentLocation] = [StudentLocation]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell") as! StudentLocationTableViewCell
        cell.nameLabel.text = "\(dictionarys[indexPath.row].firstName ?? "") \(dictionarys[indexPath.row].lastName ?? "")"
        cell.linkLabel.text = dictionarys[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let toOpen = (tableView.cellForRow(at: indexPath) as! StudentLocationTableViewCell).linkLabel.text {
            UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let _ = APIClient.sharedInstance().deleteSession(completionHandlerForDELETE: { (reultsData, error) in
            if let error = error {
                let controller = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(controller, animated: true, completion: nil)
            }
            performUIUpdatesOnMain {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
                self.present(controller, animated: true, completion: nil)
            }
            
        })
        
    }
    @IBAction func refreshBtnPreesed(_ sender: Any) {
        getTableData()
    }
    @IBAction func addBtnPressed(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getTableData()
        
    }
    
    func getTableData(){
        let _ = APIClient.sharedInstance().getStudentLocations { (result, error) in
            self.dictionarys = StudentLocation.studentLocationsFromResults(result) as [StudentLocation]
            performUIUpdatesOnMain {
                self.tableView!.reloadData()
            }
        }

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
