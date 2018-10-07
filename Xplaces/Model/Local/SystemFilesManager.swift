//
//  SystemFilesManager.swift
//  Xplaces
//
//  Created by Danielle Glazer on 20/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class SystemFilesManager {
    
    let favoritesPlacesPath:URL
    let placesListPath:URL
    
    
    init(){
        let picturesDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let favoritesPlacesPath = picturesDirectory.appendingPathComponent("favoritesplaces")
        let placesListPath = picturesDirectory.appendingPathComponent("placeslist")
        
        
        self.favoritesPlacesPath = favoritesPlacesPath!
        self.placesListPath = placesListPath!
        
        do {
            try FileManager.default.createDirectory(atPath: favoritesPlacesPath!.path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: placesListPath!.path, withIntermediateDirectories: true, attributes: nil)
            
            print("init SystemFilesManager placesListPath || favoritesPlaces directory succeeded")
        } catch let error as NSError {
            print("init SystemFilesManager placesListPath || favoritesPlaces directory fail")
            print(error.debugDescription)
        }
    }
    
    func addPlaceImagesToFavoritesPlaces(placeId:String,images:[UIImage]){
        
        let placeIdPath = self.favoritesPlacesPath.appendingPathComponent(placeId)
        do {
            try FileManager.default.createDirectory(atPath: placeIdPath.path, withIntermediateDirectories: true, attributes: nil)
            print("SystemFilesManager creating place directory in favoritesPlaces directory suceeded")
            for (index,img) in images.enumerated() {
                do {
                    let imageName = String(index)
                    if let data = UIImageJPEGRepresentation(img, 0.8) {
                        let filename = placeIdPath.appendingPathComponent(imageName)
                        try data.write(to: filename)
                        print("SystemFilesManager add Place Image To place directory in Favorites Places succeeded")
                    }
                } catch let error as NSError{
                    print("SystemFilesManager add Place Image To place directory in Favorites Places faild")
                    print(error.debugDescription)
                }
            }
        } catch let error as NSError {
            print("SystemFilesManager creating place directory in favoritesPlaces directory faild")
            print(error.debugDescription)
        }
    }
    
    
    
    
    
    
    
    
    
    func addPlaceImageToPlacesListDir(placeId:String,image:UIImage){
        
        let placeIdPath = self.placesListPath.appendingPathComponent(placeId)
        do {
            try FileManager.default.createDirectory(atPath: placeIdPath.path, withIntermediateDirectories: true, attributes: nil)
            print("SystemFilesManager creating place directory in addPlaceImagesToPlacesListDir directory suceeded")
            
            let imageName = String(0)
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let filename = placeIdPath.appendingPathComponent(imageName)
                try? data.write(to: filename)
                print("SystemFilesManager add Place Image To placesListPath directory  succeeded")
            }
        } catch let error as NSError {
            print("SystemFilesManager creating place directory in placesListPath directory faild")
            print(error.debugDescription)
        }
    }
    
    func getPlaceImageFromPlacesListImagesDir(placeId:String)->UIImage? {
        let placeNamePath = self.placesListPath.appendingPathComponent(placeId)
        let imageName = String(0)
        let filePath = placeNamePath.appendingPathComponent(imageName)
        if (FileManager.default.fileExists(atPath: filePath.path)){
            let readImage = UIImage.init(contentsOfFile: filePath.path)
            print("SystemFilesManager getPlaceImageFromPlacesListImagesDir place directory in PlacesListImagesDir succeeded")
            return readImage
        }
        else {
            print("getPlaceImageFromPlacesListImagesDir place directory in PlacesListImagesDir fail")
            return nil
        }
    }
    
    func getPlaceImagesFromFavoritePlacesDir(placeId:String)-> [UIImage] {
        let placeNamePath = self.favoritesPlacesPath.appendingPathComponent(placeId)
        var images = [UIImage]()
        let filePaths = try? FileManager.default.contentsOfDirectory(atPath: placeNamePath.path)
        
        for filePath in filePaths! {
            let url = placeNamePath.appendingPathComponent(filePath)
            let readImage = UIImage.init(contentsOfFile: url.path)
            images.append(readImage!)
        }
        return images
    }
    
    func getPlaceImagesFromPlacesListDir(placeId:String)-> [UIImage] {
        let placeNamePath = self.placesListPath.appendingPathComponent(placeId)
        var images = [UIImage]()
        let filePaths = try? FileManager.default.contentsOfDirectory(atPath: placeNamePath.path)
        
        for filePath in filePaths! {
            let url = placeNamePath.appendingPathComponent(filePath)
            let readImage = UIImage.init(contentsOfFile: url.path)
            images.append(readImage!)
        }
        return images
    }
    
 
    
    func getPlaceImageFromFavoritePlacesDir(placeId:String)->UIImage? {
        
        let placeNamePath = self.favoritesPlacesPath.appendingPathComponent(placeId)
        let imageName = String(0)
        let filePath = placeNamePath.appendingPathComponent(imageName)
        if (FileManager.default.fileExists(atPath: filePath.path)){
            let readImage = UIImage.init(contentsOfFile: filePath.path)
            print("SystemFilesManager getPlaceImageFrom place directory in FavoritePlacesDir succeeded")
            return readImage
        }
        else {
            print("getPlaceImageFrom place directory in FavoritePlacesDir fail")
            return nil
        }
    }
    
    func deletePlaceFromFavoritesPlaces(placeId:String){
        let dest = self.favoritesPlacesPath.appendingPathComponent(placeId)
        do {
            try FileManager.default.removeItem(at: dest)
            print("SystemFilesManager delete Place FromFavorites Places succeeded")
        } catch let error as NSError {
            print("SystemFilesManager deletePlaceFromFavoritesPlaces fail")
            print(error.debugDescription)
        }
    }
    
    func deletePlaceImagesFromPlacesList(placeId:String){
        let dest = self.placesListPath.appendingPathComponent(placeId)
        do {
            try FileManager.default.removeItem(at: dest)
            print("SystemFilesManager deletePlaceFromPlacesList succeeded")
        } catch let error as NSError {
            print("SystemFilesManager delete deletePlaceFromPlacesList fail")
            print(error.debugDescription)
        }
    }
    
    
}
