//
//  FavoritesPlacesTable.swift
//  Xplaces
//
//  Created by Danielle Glazer on 21/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import SQLite

class FavoritesPlacesTable {
    
    let favoritesPlacesTableName = "favoritesPlaces"
    let favoritesPlacesTable: Table!
    
    let placeId = Expression<String>("placeid")
    let name = Expression<String>("name")
    let description = Expression<String>("description")
    let country = Expression<String>("country")
    let longitude = Expression<Double>("longitude")
    let latitude = Expression<Double>("latitude")
    
    init(db:Connection){
        
        self.favoritesPlacesTable = Table(self.favoritesPlacesTableName)
        
        let createTable = self.favoritesPlacesTable.create(ifNotExists: true) { t in
            t.column(self.placeId, primaryKey: true)
            t.column(self.name)
            t.column(self.description)
            t.column(self.country)
            t.column(self.longitude)
            t.column(self.latitude)
        }
        
        do {
            try db.run(createTable)
            print("init FavoritesPlacesTable succeeded")
        } catch {
            print("init FavoritesPlacesTable fail")
            print (error)
        }
    }
    
    func addPlaceToFavorites(db:Connection,place:Place){
        let insertPlace = self.favoritesPlacesTable.insert(
            self.placeId <- place.placeId,
            self.name <- place.name,
            self.description <- place.description,
            self.country <- place.country,
            self.longitude <- place.longitude,
            self.latitude <- place.latitude
        )
        do {
            try db.run(insertPlace)
            print("FavoritesPlacesTable addPlaceToFavorites succeeded")
        } catch {
            print("FavoritesPlacesTable addPlaceToFavorites fail")
            print (error)
        }
        
    }
    
    func isPlaceInFavorites(db: Connection,placeId:String) -> Bool {
        let place = self.favoritesPlacesTable.filter(placeId == self.placeId)
        do {
            let place = try db.pluck(place)
            if place != nil {
                print("FavoritesPlacesTable isPlaceInFavorites succeeded")
            }
            return place != nil
        } catch {
            print("FavoritesPlacesTable isPlaceInFavorites fail")
            print (error)
            return false
        }
    }
    
    func getFavoritePlace(db:Connection,placeId:String)->Place?{
        let place = self.favoritesPlacesTable.filter(placeId == self.placeId)
        do {
            let dbPlace = try db.pluck(place)
            if let dbPlace = dbPlace {
                let place = Place(
                    placeId:dbPlace[self.placeId],
                    name:dbPlace[self.name],
                    description:dbPlace[self.description],
                    country: dbPlace[self.country],
                    longitude:dbPlace[self.longitude],
                    latitude:dbPlace[self.latitude])
                print("FavoritesPlacesTable getFavoritePlace succeeded")
                return place
            }
            else {
                print("FavoritesPlacesTable getFavoritePlace fail")
                return nil
            }
        } catch {
            print("FavoritesPlacesTable getFavoritePlace fail")
            print (error)
            return nil
        }
    }
    
    func deletePlaceFromFavorites(db:Connection,placeId:String){
        let place = self.favoritesPlacesTable.filter(placeId == self.placeId)
        let deletePlace = place.delete()
        do {
            try db.run(deletePlace)
            print("FavoritesPlacesTable deletePlaceFromFavorites succeeded")
        } catch {
            print("FavoritesPlacesTable deletePlaceFromFavorites fail")
            print (error)
        }
    }
    
    func getPlaces(db:Connection)->[Place] {
        
        var places = [Place]()
        
        do {
            
            let dbPlaces = try db.prepare(self.favoritesPlacesTable)
            
            for dbPlace in dbPlaces {
                let place = Place(
                    placeId:dbPlace[self.placeId],
                    name:dbPlace[self.name],
                    description:dbPlace[self.description],
                    country: dbPlace[self.country],
                    longitude:dbPlace[self.longitude],
                    latitude:dbPlace[self.latitude])
                
                places.append(place)
            }
            print("FavoritesPlacesTable getPlaces succeeded")
            return places
        } catch {
            print("FavoritesPlacesTable getPlaces fail")
            print (error)
            return places
        }
    }
}
