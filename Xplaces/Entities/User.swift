//
//  User.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation

class User : Decodable, Encodable {
    
    
    let _id:String
    let email:String
    let password:String
    let name:String
    var favorites = [String]()
    
    
    init(_id:String,email:String,password:String,name:String,favorites:[String]) {
        self._id = _id
        self.email = email
        self.password = password
        self.name = name
        self.favorites = favorites
        
    }

    
    
}
