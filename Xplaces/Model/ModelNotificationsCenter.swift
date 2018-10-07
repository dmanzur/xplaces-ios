//
//  ModelNotificationsCenter.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

class ModelNotification{
    
    static let FavoritePlaceAdded = ModelNotificationBase<String?>(name: "FavoritePlaceAddedNotification")
    static let FavoritePlaceRemoved = ModelNotificationBase<String?>(name: "FavoritePlaceRemovedNotification")
    static let GMSAutocompleteResultsViewControllerDisappear = ModelNotificationBase<Bool>(name: "GMSAutocompleteResultsViewControllerDisappearNotification")


    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
        print("observer removed")
    }
}

