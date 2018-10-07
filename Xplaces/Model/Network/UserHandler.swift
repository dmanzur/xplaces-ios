//
//  AuthenticationHandler.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


class UserHandler {
    
    let baseUrl = appKeys["server"]! + "users/"
 

    
    func loginUser(email:String, password:String,loginCallback:@escaping (User?)->Void){
        print("UserHandler: loginUser")
        let destinationUrl = self.baseUrl + "login"
        
        let body = "email=" + email + "&password=" + password
        let postData = body.data(using: .utf8)
        
        guard let url = URL(string:destinationUrl)
            else {
                print("UserHandler url error")
                loginCallback(nil)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.httpBody = postData
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let _ = response, let data = data {
                do{
                    print("UserHandler: loginUser: got data");
                    let user = try JSONDecoder().decode(User.self, from: data)
                    
                    let saveSuccessfulEmail: Bool = KeychainWrapper.standard.set(email, forKey: "userEmail")
                    let saveSuccessfulPass: Bool = KeychainWrapper.standard.set(password, forKey: "userPassword")
                    
                    if !saveSuccessfulEmail || !saveSuccessfulPass {
                        print("UserHandler KeychainWrapper error")
                    }
                    loginCallback(user)
                }
                catch{
                    print("UserHandler: loginUser: error")
                    loginCallback(nil)
                    
                }
            }
            else {
                print("UserHandler: loginUser: error")
                loginCallback(nil)
            }
            }.resume()
    }
    
    func registerUser(name:String,email:String,password:String,registerCallback:@escaping (User?)->Void){
        
        let destinationUrl = self.baseUrl + "register"
        
        let body = "name=" + name + "&email=" + email + "&password=" + password
        let postData = body.data(using: .utf8)
        
        guard let url = URL(string:destinationUrl)
            else {
                print("UserHandler url error")
                registerCallback(nil)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.httpBody = postData
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let _ = response, let data = data {
                do{
                    print("UserHandler: registerUser: got data");
                    let user = try JSONDecoder().decode(User.self, from: data)
                    registerCallback(user)
                }
                catch{
                    print("UserHandler: registerUser: error")
                    registerCallback(nil)
                }
            }else {
                print("UserHandler: registerUser: error")
                registerCallback(nil)
            }
            }.resume()
        
    }
    
    func logoutUser(logoutCallback:@escaping (Bool)->Void){
        print("UserHandler : logoutUser")
        let destinationUrl = self.baseUrl + "logout"
        guard let url = URL(string:destinationUrl)
            else {
                print("UserHandler url error")
                logoutCallback(false)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let _ = response, let data = data {
                do{
                    print("UserHandler: logoutUser: got data");
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:Bool]
                    let value = json["value"]!
                    KeychainWrapper.standard.removeObject(forKey: "userEmail")
                    KeychainWrapper.standard.removeObject(forKey: "userPassword")
                    
                    logoutCallback(value)
                }
                catch{
                    print("UserHandler: logoutUser: error")
                    logoutCallback(false)
                }
            }else {
                print("UserHandler: logoutUser: error")
                logoutCallback(false)
            }
            }.resume()
    }
    
    func removeFavoritePlace(placeId: String,callback: @escaping (Bool) -> Void){
        
        let destination = self.baseUrl + "favorites/remove/\(placeId)"
        guard let url = URL(string: destination)
            else {
                print("UserHandler: removeFavoritePlace :url error")
                callback(false)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if response != nil && data != nil {
                print("UserHandler: Favorite Place removed from server");
                callback(true)
            }
            else {
                print("UserHandler: removeFavoritePlace from server: error")
                callback(false)
            }
            }.resume()
    }
    
    
    func addFavoritePlaceIdToUser(placeId: String,callback: @escaping (Bool) -> Void){
        
        let destination =  self.baseUrl + "favorites/add/\(placeId)"
        print("UserHandler: addFavoritePlaceIdToUser");
        guard let url = URL(string:destination)
            else {
                print("UserHandler: addFavoritePlaceIdToUser: url error")
                callback(false)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if response != nil && data != nil {
                print("UserHandler: addFavoritePlaceIdToUser in server succeeded");
                callback(true)
            }
            else {
                print("UserHandler: addFavoritePlaceIdToUser: error")
                callback(false)
            }
            }.resume()
    }
    
    
}
