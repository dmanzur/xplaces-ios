//
//  AuthenticationService.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class UserService {
    

    static let sharedInstance = UserService()
    
    private init(){}
    
    func login(email: String, password: String, callback: @escaping (User?) -> Void) {
        NetworkManager.SharedInstance.loginUser(email: email, password: password, loginCallback: callback)
    }
    
    func register(name: String, email: String, password: String, callback: @escaping (User?) -> Void) {
        NetworkManager.SharedInstance.registerUser(name: name, email: email, password: password, registerCallback: callback)
    }
    
    func logout(callback: @escaping (Bool) -> Void) {
        NetworkManager.SharedInstance.logoutUser(logoutCallback: callback)
    }
    
    func deletePlaceFromFavorites(placeId:String){
        NetworkManager.SharedInstance.removePlaceIdFromFavorites(placeId: placeId) { (value) in
            if value {
                LocalManager.SharedInstance.deletePlaceFromFavorites(placeId: placeId)
                ModelNotification.FavoritePlaceRemoved.post(data: placeId)
            } else {
                ModelNotification.FavoritePlaceRemoved.post(data: nil)
            }
        }
    }
    
    func addPlaceToFavorites(place:Place,placeImages:[UIImage]){
        NetworkManager.SharedInstance.addPlaceIdToFavorites(placeId: place.placeId) { (value) in
            if value {
                LocalManager.SharedInstance.addPlaceToFavorites(place: place,placeImages:placeImages)
                ModelNotification.FavoritePlaceAdded.post(data: place.placeId)
            }
            else {
                ModelNotification.FavoritePlaceAdded.post(data: nil)
            }
        }
    }
    
}
