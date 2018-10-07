//
//  PlacesList.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit
import GooglePlaces



class PlacesList: UIViewController {
    
    let myActivityIndicator = UIActivityIndicatorView()
    var GMSAutocompleteResultsViewControllerObserver:Any?
    var places : [Place] = []
    var myIndex = 0
    var placeToPass:Place?
    var placeToSearch :GMSPlace?
    var placeImagesToPass: [UIImage]?
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get places
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        self.setResultsViewControllerObserver()
        
    }
    
    private func setResultsViewControllerObserver(){
        self.GMSAutocompleteResultsViewControllerObserver = ModelNotification.GMSAutocompleteResultsViewControllerDisappear.observe(callback: { (value) in
            if self.placeToSearch != nil {
                self.myActivityIndicator.create(vc: self)
                self.myActivityIndicator.startAnimating()
                self.getPlaceForGoogleRequest(callback: { (place,images) in
                    DispatchQueue.main.async {
                        self.myActivityIndicator.stopAnimating()
                        if let place = place,let images = images {
                            self.placeToPass = place
                            self.placeImagesToPass = images
                            self.performSegue(withIdentifier: "placeDetailsSegue", sender: self)
                        }
                        else {
                            Utils.presentAlert(title: "Place not found", msg: "place could not be found", vc: self)
                        }
                    }
                })
            }
        })
    }
    
    private func getPlaceForGoogleRequest(callback:@escaping (Place?,[UIImage]?)->Void){
        var images : [UIImage]?
        var place : Place?
        var callsLeft = 2
        
        //CREATE CUSTOM PLACE OBJECT
        PlacesService.sharedInstance.getGooglePlace(place:self.placeToSearch!,callback: {(callbackPlace) in
            place = callbackPlace
            callsLeft = callsLeft - 1
            if callsLeft == 0 {
                callback(place,images)
            }
        })
        
        //GET PLACE PHOTOS
        PlacesService.sharedInstance.getGooglePlaceImages(placeId: self.placeToSearch!.placeID,callback: { (callbackImages) in
            images = callbackImages!
            callsLeft = callsLeft - 1
            if callsLeft == 0 {
                callback(place,images)
            }
        })
    }
}

extension GMSAutocompleteResultsViewController {
    
    open override func viewDidDisappear(_ animated: Bool) {
        ModelNotification.GMSAutocompleteResultsViewControllerDisappear.post(data: true)
    }
}

extension PlacesList: GMSAutocompleteResultsViewControllerDelegate {
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        // Do something with the selected place.
        print("Place name selected: \(place.name)")
        print("Place id selected: \(place.placeID)")
        self.placeToSearch = place
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension PlacesList: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = self.places[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlacesListCell
        cell.setPlace(place: place)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myIndex = indexPath.row
        self.myActivityIndicator.create(vc: self)
        self.myActivityIndicator.startAnimating()
        let place = self.places[self.myIndex]
        PlacesService.sharedInstance.getGooglePlaceImages(placeId: place.placeId,callback: { (images) in
            DispatchQueue.main.async {
                self.myActivityIndicator.stopAnimating()
                self.tableView.deselectRow(at: indexPath, animated: true)
                if let images = images {
                    self.placeToPass = place
                    self.placeImagesToPass = images
                    self.performSegue(withIdentifier: "placeDetailsSegue", sender: self)
                }
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlaceDetails
        {
            let vc = segue.destination as? PlaceDetails
            vc?.place = self.placeToPass
            vc?.placeImages = self.placeImagesToPass!
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
    }
    
}





