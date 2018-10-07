//
//  FavoritesListCell.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit



class FavoritesListCell: UITableViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    
    func setPlace(place:Place){
        
        self.placeNameLabel.text = place.name
        self.placeImage.image = PlacesService.sharedInstance.getPlaceImageFromFavoritesPlaces(placeId:place.placeId)
    
    }

}
