//
//  RiderViewController.swift
//  firUber
//
//  Created by M.Murtaza on 11/17/17.
//  Copyright © 2017 M.Murtaza. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import CoreLocation
class RiderViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var callbtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        
        if let email = Auth.auth().currentUser?.email {
            Database.database().reference().child("RiderReq").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.uberHasBeenCalled = true
                self.callbtn.setTitle("Cancel Uber", for: .normal)
                Database.database().reference().child("RiderReq").removeAllObservers()
            })
        }
    }
//current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let coord = manager.location?.coordinate{
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
        }
        print("logitue is \(userLocation.longitude)    latitude is \(userLocation.longitude)")
    }

    @IBAction func callanuber(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email {
            
            if uberHasBeenCalled {
                uberHasBeenCalled = false
                callbtn.setTitle("Call an Uber", for: .normal)
                Database.database().reference().child("RiderReq").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                    snapshot.ref.removeValue()
                    Database.database().reference().child("RiderReq").removeAllObservers()
                })
            } else {
                let rideRequestDictionary : [String:Any] = ["email":email,"lat":userLocation.latitude,"long":userLocation.longitude]
                Database.database().reference().child("RiderReq").childByAutoId().setValue(rideRequestDictionary)
                uberHasBeenCalled = true
                callbtn.setTitle("Cancel Uber", for: .normal)
            }
            
            
        }
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
