//
//  PlacesListCell.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit


class PlacesListCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var placeImage: UIImageView!
    
    
    @IBOutlet weak var placeDescriptionLabel: UILabel!    
    
    
    func setPlace(place:Place){
        
        print("place id is: \(place.placeId)")
        self.placeNameLabel.text = place.name + ", " + place.country
        self.placeDescriptionLabel.text = "Description: " + place.description
        PlacesService.sharedInstance.getGooglePlaceImage(placeId: place.placeId,callback: { (image) in
            if let image = image {
                self.placeImage.image = image
            }
        })
        
    }
    
}
