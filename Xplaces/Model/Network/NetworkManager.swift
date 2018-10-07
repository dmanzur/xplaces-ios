//
//  NetworkManager.swift
//  Explaces
//
//  Created by Danielle Glazer on 17/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class NetworkManager {
    
    static let SharedInstance = NetworkManager()
    
    let userHandler = UserHandler()
    let placesHandler = PlacesHandler()
    
    private init(){}
 
    func getPlacesIdsList(callback: @escaping ([String]?) -> Void){
        self.placesHandler.getPlacesIdsList(callback: callback)
    }
    
    func searchImage(image: UIImage, callback: @escaping (String?) -> Void) {
        self.placesHandler.searchImage(image:image,callback: callback)
    }
    
    func loginUser(email:String,password:String,loginCallback:@escaping (User?)->Void){
        self.userHandler.loginUser(email: email, password: password, loginCallback: loginCallback)
    }
    
    
    func logoutUser(logoutCallback:@escaping (Bool)->Void){
        self.userHandler.logoutUser(logoutCallback:logoutCallback);
    }
    
    func registerUser(name: String, email:String, password:String,registerCallback:@escaping (User?)->Void){
        self.userHandler.registerUser(name:name,email:email,password:password,registerCallback:registerCallback);
    }
    
    
    func removePlaceIdFromFavorites(placeId: String,callback: @escaping (Bool) -> Void){
        self.userHandler.removeFavoritePlace(placeId:placeId,callback:callback)
    }
    
    func addPlaceIdToFavorites(placeId:String,callback: @escaping (Bool) -> Void){
        
        self.userHandler.addFavoritePlaceIdToUser(placeId:placeId,callback:callback)
        
    }
    
    func getPlaceDescription(placeName:String,callback:@escaping (String?)->Void){
        self.placesHandler.getPlaceDescription(placeName:placeName,callback: callback)
    }
}

