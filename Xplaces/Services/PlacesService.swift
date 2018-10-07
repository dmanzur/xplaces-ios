//
//  PlacesService.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces


class PlacesService {
    
    
    static let sharedInstance = PlacesService()
    private init(){}
    
    
    func getPlaceImagesFromFavoritesPlaces(placeId:String) -> [UIImage] {
        return LocalManager.SharedInstance.getPlaceImagesFromFavoritesPlacesDir(placeId: placeId)
    }
    
    func getFavoritePlace(placeId:String)->Place? {
        return LocalManager.SharedInstance.getFavoritePlace(placeId:placeId)
    }
    
    
    func isPlaceInFavorites(placeId: String) -> Bool {
        return LocalManager.SharedInstance.isPlaceInFavorites(placeId: placeId)
    }
    
    
    func getPlaceImageFromFavoritesPlaces(placeId: String) -> UIImage? {
        return  LocalManager.SharedInstance.getPlaceImageFromFavoritesPlacesDir(placeId: placeId)
    }
    
    
    func searchImage(image: UIImage, callback: @escaping (Place?) -> Void) {
        NetworkManager.SharedInstance.searchImage(image:image,callback: {(placeId) in
            if let placeId = placeId {
                DispatchQueue.main.async {
                    GMSPlacesClient.shared().lookUpPlaceID(placeId,callback: { (place, error) -> Void in
                        if error != nil {
                            callback(nil)
                        }
                        self.getGooglePlace(place:place!,callback: {(placeCreated) in
                            if let placeCreated = placeCreated {
                                callback(placeCreated)
                            }
                        })
                    })
                }
            } else {
                callback(nil)
            }
        })
        
    }
    
    func getFavoritesPlaces() -> [Place]{
        return LocalManager.SharedInstance.getFavoritesPlaces()
    }
    
    func getPlaces(callback: @escaping ([Place]?) -> Void) {
        
        NetworkManager.SharedInstance.getPlacesIdsList(callback:{(placesIds) in
            if let placesIds = placesIds {
                DispatchQueue.main.async {
                    var places = [Place]()
                    var counter = 0
                    for placeId in placesIds {
                        GMSPlacesClient.shared().lookUpPlaceID(placeId,callback: { (place, error) -> Void in
                            if error != nil {
                                callback(nil)
                            }
                            self.getGooglePlace(place:place!,callback: {(placeCreated) in
                                if let placeCreated = placeCreated {
                                    places.append(placeCreated)
                                }
                                counter = counter + 1
                                if counter == placesIds.count {
                                    callback(places)
                                }
                            })
                        })
                    }
                }
            }
        })
    }
    
    
    
    func getGooglePlace(place:GMSPlace, callback: @escaping (Place?) -> Void){
        NetworkManager.SharedInstance.getPlaceDescription(placeName: place.name, callback: { (description) in
            if let description = description {
                let place = Utils.getPlaceDetails(place:place,description:description)
                callback(place)
            } else {
                callback(nil)
            }
        })
    }
    
    
    func getGooglePlaceImage(placeId:String,callback: @escaping (UIImage?) -> Void){
        
        if let image = LocalManager.SharedInstance.getPlaceImageFromPlacesListImagesDir(placeId: placeId){
            callback(image)
        }
        else {
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeId, callback: { (photos, error) -> Void in
                if let error = error {
                    print(error)
                    callback(nil)
                } else {
                    if let photo = photos?.results.first {
                        GMSPlacesClient.shared().loadPlacePhoto(photo, callback: { (photo,error) -> Void in
                            if let error = error {
                                print(error)
                                callback(nil)
                            }
                            else {
                                LocalManager.SharedInstance.addPlaceImageToPlacesListDir(placeId:placeId,image:photo!)
                                callback(photo)
                            }
                        })
                    }
                    else {
                        callback(nil)
                    }
                }
            })
        }
    }
    
    
    
    func getGooglePlaceImages(placeId:String,callback: @escaping ([UIImage]?) -> Void){
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeId, callback: { (photos, error) -> Void in
            if let error = error {
                print(error)
                callback(nil)
            } else {
                if let photos = photos?.results {
                    var placeImages = [UIImage]()
                    var counter = 0
                    for photo in photos {
                        GMSPlacesClient.shared().loadPlacePhoto(photo, callback: { (photo,error) -> Void in
                            counter = counter + 1
                            if let error = error {
                                print(error)
                                callback(nil)
                            }
                            else {
                                placeImages.append(photo!)
                            }
                            if counter == photos.count {
                                callback(placeImages)
                            }
                        })
                    }
                }
            }
        })
    }
}
