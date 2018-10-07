//
//  Authentication.swift
//  Explaces
//
//  Created by Danielle Glazer on 17/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit

class Authentication: UIViewController {
    
    @IBOutlet weak var registerBtnOutlet: UIButton!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginBtnOutlet.layer.cornerRadius = 20
        self.loginBtnOutlet.clipsToBounds = true
        
        self.registerBtnOutlet.layer.cornerRadius = 20
        self.registerBtnOutlet.clipsToBounds = true
        
    }

    

    
}
