//
//  InfoPostingVC.swift
//  OnTheMap
//
//  Created by Sarah Alhumud on 02/06/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishBtn: UIButton!
    
    var studentLocation: StudentInformation!
    var mapString: String = ""
    var link: String = ""
    var matchingItems:[MKMapItem] = []
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        self.postLocation()
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchLocation()
        
    }
    
    func searchLocation(){
        setUIEnabled(false)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = mapString
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let error = error {
                self.showAlert(title: "", msg: "\(error.localizedDescription)")
            }
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            let placemark = self.matchingItems[0].placemark
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            
            self.mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
            self.coordinate = annotation.coordinate
            self.setUIEnabled(true)
            
        }
    }
    
    func postLocation(){
        let _ = APIClient.sharedInstance().getUserName { (first, last, nickname, error) in
            if let error = error {
                self.showAlert(title: "", msg: "\(error.localizedDescription)")
            }
            print(nickname)
            self.studentLocation = StudentInformation(id: "", key: "", first: first, last: last, map: self.mapString, url: self.link, lat: self.coordinate.latitude, long: self.coordinate.longitude)
            let _ = APIClient.sharedInstance().postStudentLocation(studentLocation: self.studentLocation, completionHandlerForPOST: { (resultJSON, error) in
                if let error = error {
                    self.showAlert(title: "", msg: "\(error.localizedDescription)")
                }
                if let error = error {
                    let controller = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(controller, animated: true, completion: nil)
                }
                print("Sucesssssssss :)")
                self.dismiss(animated: true, completion: nil)
            })
            
            
        }
    }
    
    func showAlert(title: String, msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func setUIEnabled(_ enabled: Bool) {
        
        finishBtn.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            finishBtn.alpha = 1.0
        } else {
            finishBtn.alpha = 0.5
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
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
