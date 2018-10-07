//
//  Place.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class Place : Decodable , Encodable{
    

    let placeId:String
    let name:String
    let description:String
    let longitude:Double
    let latitude:Double
    let country:String
    
    
    
    init(placeId:String,name:String,description:String,country:String,longitude:Double,latitude:Double){
        self.placeId = placeId
        self.name = name
        self.description = description
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
    
    
}
