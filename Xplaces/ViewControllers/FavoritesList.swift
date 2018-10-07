//
//  FavoritesList.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit

class FavoritesList: UIViewController {
    
    
    var favoritePlaceRemovedObserver:Any?
    var favoritePlaceAddedObserver:Any?
    var places : [Place] = []
    var myIndex = 0
    var imagesToPass = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.places = PlacesService.sharedInstance.getFavoritesPlaces()
       
        self.favoritePlaceAddedObserver = ModelNotification.FavoritePlaceAdded.observe(callback: { (value) in
            DispatchQueue.main.async {
                if value != nil {
                    if let place = PlacesService.sharedInstance.getFavoritePlace(placeId:value!!){
                        self.places.insert(place, at: 0)
                        self.tableView.reloadData()
                        print("UIViewController FavoritesList : added to favorite")
                    }
                }
                else {
                    print("UIViewController FavoritesList : not added to favorite")
                }
            }
        })
        
        self.favoritePlaceRemovedObserver = ModelNotification.FavoritePlaceRemoved.observe(callback: { (value) in
            DispatchQueue.main.async {
                print("UIViewController FavoritesList favoritePlaceRemovedObserver")
                if value != nil {
                    for (index, place) in self.places.enumerated(){
                        if  place.placeId == value {
                            self.places.remove(at: index)
                            self.tableView.reloadData()
                            print("UIViewController FavoritesList : removed from favorite")
                            break
                        }
                    }
                }
                else {
                    print("UIViewController FavoritesList : not removed from favorite")
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
    }
    
}


extension FavoritesList: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = self.places[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoritesListCell
        cell.setPlace(place:place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.myIndex = indexPath.row
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.imagesToPass = PlacesService.sharedInstance.getPlaceImagesFromFavoritesPlaces(placeId: places[self.myIndex].placeId)
        self.performSegue(withIdentifier: "favoriteDetailsSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlaceDetails
        {
            let vc = segue.destination as? PlaceDetails
            let place = places[self.myIndex]
            vc?.place = place;
            vc?.placeImages = self.imagesToPass
        }
    }
    
    
}
