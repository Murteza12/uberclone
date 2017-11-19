//
//  AcceptDriverViewController.swift
//  firUber
//
//  Created by M.Murtaza on 11/18/17.
//  Copyright © 2017 M.Murtaza. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
class AcceptDriverViewController: UIViewController , CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var email = " "
    var requestlocation = CLLocationCoordinate2D()
       var driverlocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: requestlocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestlocation
        annotation.title = email
        map.addAnnotation(annotation)
        print(" driverlongitude \(driverlocation.longitude)  --  driverlatitde  \(driverlocation.latitude)")
          print(" Request longitude \(driverlocation.longitude)  --  Request latitde  \(driverlocation.latitude)")

       
    }

    @IBAction func Acceptrequest(_ sender: Any) {
        Database.database().reference().child("RiderReq").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat":self.driverlocation.latitude, "driverLon":self.driverlocation.longitude])
            Database.database().reference().child("RiderReq").removeAllObservers()
            print("driver lat \(self.driverlocation.latitude)   ----- long    \(self.driverlocation.longitude)")
        }
        
        // Give directions
        
        let requestCLLocation = CLLocation(latitude: requestlocation.latitude, longitude: requestlocation.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.email
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
        
    }
    

}
