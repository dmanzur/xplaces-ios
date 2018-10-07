//
//  LocalManager.swift
//  Xplaces
//
//  Created by Danielle Glazer on 21/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit

class LocalManager  {
    
    static let SharedInstance = LocalManager()
    let systemFileManager = SystemFilesManager()
    let sqliteManager = SQLiteManager()
    
    private init(){}

    func deletePlaceFromFavorites(placeId:String){
        //remove from sql
        self.sqliteManager.deletePlaceFromFavorites(placeId:placeId)
        
        //remove from file system
        self.systemFileManager.deletePlaceFromFavoritesPlaces(placeId: placeId)
    }
    
    func addPlaceToFavorites(place:Place,placeImages:[UIImage]){
        //add to sql
        self.sqliteManager.addPlaceToFavorites(place:place)
        
        //add to file system
        self.systemFileManager.addPlaceImagesToFavoritesPlaces(placeId: place.placeId, images: placeImages)
    }
    
    
    func isPlaceInFavorites(placeId: String) -> Bool {
        return self.sqliteManager.isPlaceInFavorites(placeId: placeId)
    }
    
    
    func getPlaceImageFromFavoritesPlacesDir(placeId: String) -> UIImage? {
        return self.systemFileManager.getPlaceImageFromFavoritePlacesDir(placeId: placeId)
    }
    
    func getPlaceImagesFromFavoritesPlacesDir(placeId: String) -> [UIImage] {
        return self.systemFileManager.getPlaceImagesFromFavoritePlacesDir(placeId: placeId)
    }
    
    func getFavoritesPlaces()->[Place]{
        let places =  self.sqliteManager.getFavoritesPlaces()
        return places
    }
    
    func getFavoritePlace(placeId:String) -> Place? {
        let place = self.sqliteManager.getFavoritePlace(placeId:placeId)
        if let place = place {
            return place
        } else {
            return nil
        }
    }
    
    func getPlaceImageFromPlacesListImagesDir(placeId:String) -> UIImage? {
        return self.systemFileManager.getPlaceImageFromPlacesListImagesDir(placeId: placeId)
    }
    
    func addPlaceImageToPlacesListDir(placeId:String,image:UIImage) {
        return self.systemFileManager.addPlaceImageToPlacesListDir(placeId: placeId,image: image)
    }
    
    
}
