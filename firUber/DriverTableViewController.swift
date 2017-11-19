//
//  DriverTableViewController.swift
//  firUber
//
//  Created by M.Murtaza on 11/17/17.
//  Copyright © 2017 M.Murtaza. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
class DriverTableViewController: UITableViewController , CLLocationManagerDelegate{
    var rideRequests : [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        Database.database().reference().child("RiderReq").observe(.childAdded) { (snapshot) in
            self.rideRequests.append(snapshot)
            print("rider request is \(self.rideRequests)")
            print("total request is \(self.rideRequests.count)")
            self.tableView.reloadData()
    }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }

    

    @IBAction func loguttapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideRequests.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = rideRequests[indexPath.row]
        performSegue(withIdentifier: "AcceptDriver", sender: snapshot)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drivercell", for: indexPath) 

        let snapshot = rideRequests[indexPath.row]
      //  cell.textLabel?.text = "hello"
        if let rideRequestDictionary = snapshot.value as? NSDictionary {
            if let email = rideRequestDictionary["email"] as? String {
                if let lat = rideRequestDictionary["lat"] as? Double {
                    if let long = rideRequestDictionary["long"] as? Double {
                        
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: lat, longitude: long)
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundedDistance = round(distance * 100) / 100
                        
                        
                        print("all email is \(email)")
                        cell.textLabel?.text = "\(email) - \(roundedDistance)km away"
                    }
                }
                
                
            }
        }
        
        return cell

      
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? AcceptDriverViewController {
            if let snapshot = sender as? DataSnapshot {
                if let rideRequestDictionary = snapshot.value as? NSDictionary {
                    if let email = rideRequestDictionary["email"] as? String {
                        if let lat = rideRequestDictionary["lat"] as? Double {
                            if let lon = rideRequestDictionary["lon"] as? Double {
                                acceptVC.email = email
                                 let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                acceptVC.requestlocation = location
                                acceptVC.driverlocation = driverLocation
                            }
                        }
                    }
                }
            }
        }
    }
   
}
