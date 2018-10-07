//
//  AboutAndLogout.swift
//  Xplaces
//
//  Created by Danielle Glazer on 20/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit


class AboutAndLogout: UIViewController {
    
    @IBOutlet weak var aboutContentLabel: UILabel!
    
    lazy var myActivityIndicator = UIActivityIndicatorView()
    let text = "But this is completely erroneous, and our view may be corroborated by actual observation more effectively than by any sort of verbal argument. For if you let fall from the same height two weights of which one is many times as heavy as the other, you will see that the ratio of the times required for the motion does not depend on the ratio of the weights, but that the difference in time is a very small one. And so, if the difference in the weights is not considerable, that is, of one is, let us say, double the other, there will be no difference, or else an imperceptible difference, in time, though the difference in weight is by no means negligible, with one body weighing twice as much as the other But this is completely erroneous, and our view may be corroborated by actual observation more effectively than by any sort of verbal argument. For if you let fall from the same height two weights of which one is many times as heavy as the other, you will see that the ratio of the times required for the motion does not depend on the ratio of the weights, but that the difference in time is a very small one. And so, if the difference in the weights is not considerable, that is, of one is, let us say, double the other, there will be no difference, or else an imperceptible difference, in time, though the difference in weight is by no means negligible, with one body weighing twice as much as the other as heavy as the other, you will see that the ratio of the times required for the motion does not depend on the ratio of the weights, but that the difference in time is a very small one. And so, if the difference in the weights is not considerable, that is, of one is, let us say, double the other, there will be no difference, or else an imperceptible difference, in time, though the difference in weight is by no means negligible, with one body weighing twice as much as the other"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutContentLabel.text = self.text
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        self.myActivityIndicator.create(vc: self)
        self.myActivityIndicator.startAnimating()
        UserService.sharedInstance.logout { (value) in
            DispatchQueue.main.async {
                self.myActivityIndicator.stopAnimating()
                if value {
                    print("AboutAndLogout user is logout")
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    print("AboutAndLogout user is not logout")
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}
