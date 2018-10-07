//
//  Parser.swift
//  Xplaces
//
//  Created by Danielle Glazer on 28/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import GooglePlaces
import UIKit


class Utils {
    
    static func getPlaceDescription(placeDescriptionJson:Dictionary<String, Any>)->String?{
        let annotations = placeDescriptionJson["annotations"] as! [Any]
        if annotations.isEmpty {
            return nil
        }
        else {
            let first = annotations.first as! Dictionary<String, Any>
            let abstract = first["abstract"] as! String
            return abstract
        }
    }
    
    static func getPlaceDetails(place:GMSPlace,description:String) -> Place{
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let name = place.name
        let placeId = place.placeID
        var country = "?"
        for component in place.addressComponents! {
            if component.type == "country"{
                country = component.name
            }
        }
        let place = Place(placeId: placeId, name: name,description:description, country: country, longitude: longitude, latitude: latitude)
        return place
    }
    
    static func getPlacesIds(placesIdsJson:[Dictionary<String, Any>])->[String]{
    
        var placesIds = [String]()
        for place in placesIdsJson {
            let placeId = place["placeId"] as! String
            placesIds.append(placeId)
            print(placeId)
        }
        
        return placesIds
    }
    
    static func presentAlert(title:String,msg:String,vc:UIViewController) {
        let myAlert = UIAlertController(title:title,message: msg, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title:"ok",style: .default, handler: nil))
        vc.present(myAlert, animated: true)
    }

}
