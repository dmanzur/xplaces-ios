//
//  SQLiteManager.swift
//  Xplaces
//
//  Created by Danielle Glazer on 21/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import SQLite

class SQLiteManager {
    
    var database: Connection!
    var favoritesPlacesTable: FavoritesPlacesTable!
    
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("db").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.favoritesPlacesTable = FavoritesPlacesTable(db:self.database)
            print("init database succeeded")
        } catch {
            print("init database fail")
            print(error)
        }
    }
    
    
    func isPlaceInFavorites(placeId: String) -> Bool {
        return self.favoritesPlacesTable.isPlaceInFavorites(db:self.database,placeId:placeId)
    }
    
    func addPlaceToFavorites(place: Place){
        self.favoritesPlacesTable.addPlaceToFavorites(db:self.database,place:place)
    }
    
    func deletePlaceFromFavorites(placeId:String){
        self.favoritesPlacesTable.deletePlaceFromFavorites(db:self.database,placeId:placeId)
    }
    
    func getFavoritesPlaces()->[Place] {
        return self.favoritesPlacesTable.getPlaces(db:self.database)
    }
    
    func getFavoritePlace(placeId:String)->Place?{
        return self.favoritesPlacesTable.getFavoritePlace(db:self.database,placeId:placeId)
    }
    
}
