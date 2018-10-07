//
//  UIActivityIndicatorViewExtension.swift
//  Xplaces
//
//  Created by Danielle Glazer on 22/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    func create(vc:UIViewController){
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.hidesWhenStopped = true
        self.frame = CGRect(x: UIScreen.main.bounds.size.width*0.5 - 60.0, y: UIScreen.main.bounds.size.height*0.5 - 60.0, width: 120.0, height: 120.0)
        vc.view.addSubview(self)
    }
}
