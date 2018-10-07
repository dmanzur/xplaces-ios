//
//  Start.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class Start: UIViewController {
    
    var places : [Place] = []
    let myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue){}
    
    override func viewDidAppear(_ animated: Bool) {
        
        let email: String? = KeychainWrapper.standard.string(forKey: "userEmail")
        let password: String? = KeychainWrapper.standard.string(forKey: "userPassword")
        
        if let email = email,let password = password {
            print("Start :KeychainWrapper good")
            self.login(email: email, password: password)
        }
        else {
            print("Start :KeychainWrapper bad")
            self.performSegue(withIdentifier: "authSegue", sender: self)
        }
    }
    
    
    private func login(email: String, password: String){
        self.myActivityIndicator.create(vc: self)
        self.myActivityIndicator.startAnimating()
        UserService.sharedInstance.login(email: email, password: password) { (user) in
            if user != nil {
                DispatchQueue.main.async {
                    PlacesService.sharedInstance.getPlaces(callback:  { (places) in
                        DispatchQueue.main.async {
                            self.myActivityIndicator.stopAnimating()
                            if places != nil {
                                self.places = places!
                                self.performSegue(withIdentifier: "tabBarSegue", sender: self)
                            } else {
                                print("Start places is nil")
                            }
                        }
                    })
                }
            }
            else {
                DispatchQueue.main.async {
                    self.myActivityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "authSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UITabBarController
        {
            let barViewControllers = segue.destination as? UITabBarController
            let nav = barViewControllers?.viewControllers![0] as! UINavigationController
            let vc = nav.topViewController as? PlacesList
            vc?.places = self.places
        }
    }
    
    
}
