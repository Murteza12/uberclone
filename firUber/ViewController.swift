//
//  ViewController.swift
//  firUber
//
//  Created by M.Murtaza on 11/16/17.
//  Copyright © 2017 M.Murtaza. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var switchcont: UISwitch!
    @IBOutlet weak var bottombtn: UIButton!
    @IBOutlet weak var topbtn: UIButton!
    @IBOutlet weak var driverfield: UILabel!
    @IBOutlet weak var riderfield: UILabel!
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var emailfield: UITextField!
    var signUpMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func topbtnpressed(_ sender: Any) {
        if emailfield.text == "" || passwordfield.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both a email and password")
        } else {
            if let email = emailfield.text {
                if let password = passwordfield.text {
                    if signUpMode {
                        // SIGN UP
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Sign Up Success")
                                self.emailfield.text = ""
                                self.passwordfield.text = ""
                                if self.switchcont.isOn {
                                
                                    // RIDER
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "riderseg", sender: nil)
                                
                                    
                                } else {
                                    //driver
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverseg", sender: nil)
                                    
                                    
                                }
                               
                            }
                        })
                    } else {
                        // LOG IN
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                print("Log In Success")
                                if user?.displayName == "Driver" {
                                    // DRIVER
                                    self.performSegue(withIdentifier: "driverseg", sender: nil)
                                } else {
                                    // RIDER
                                    self.performSegue(withIdentifier: "riderseg", sender: nil)
                                }
                                //self.performSegue(withIdentifier: "riderseg", sender: nil)
                            }
                        })
                    }
                }
            }
        }
        
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func bottompressed(_ sender: Any) {
        if signUpMode {
            topbtn.setTitle("Log In", for: .normal)
            bottombtn.setTitle("Switch to Sign Up", for: .normal)
            riderfield.isHidden = true
            driverfield.isHidden = true
            switchcont.isHidden = true
            signUpMode = false
        } else {
            topbtn.setTitle("Sign Up", for: .normal)
            bottombtn.setTitle("Switch to Log In", for: .normal)
            riderfield.isHidden = false
            driverfield.isHidden = false
            switchcont.isHidden = false
            signUpMode = true
        }
    }
}

