//
//  PlaceDetails.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit


class PlaceDetails: UIViewController {
    
    var placeImages = [UIImage]()
    var favoritePlaceRemovedObserver:Any?
    var favoritePlaceAddedObserver:Any?
    var place: Place!
    lazy var myActivityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeCountryLabel: UILabel!
    @IBOutlet weak var favoriteBtnOutlet: UIButton!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PlaceDetails.addTapped))
        
        self.initScrollViewAndPageController()
        self.placeName.text = self.place?.name
        self.placeCountryLabel.text = "Country: " + self.place!.country
        let description = self.place?.description
        self.placeDescriptionLabel.text = description!
        if PlacesService.sharedInstance.isPlaceInFavorites(placeId: self.place!.placeId){
            self.favoriteBtnOutlet.setImage(#imageLiteral(resourceName: "fav-full"),for:.normal)
        } else {
            self.favoriteBtnOutlet.setImage(#imageLiteral(resourceName: "fav-empty"),for:.normal)
        }
    }
    
    @objc func addTapped(){
        let image = self.placeImages[self.pageControl.currentPage]
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func mapBtn(_ sender: Any) {
        performSegue(withIdentifier: "mapSegue", sender: self)
    }
    
    
    @IBAction func favoriteBtn(_ sender: Any) {
        self.myActivityIndicator.create(vc: self)
        self.myActivityIndicator.startAnimating()
        if self.favoriteBtnOutlet.currentImage == #imageLiteral(resourceName: "fav-empty") {
            UserService.sharedInstance.addPlaceToFavorites(place: self.place!,placeImages: self.placeImages)
        }
        else {
            UserService.sharedInstance.deletePlaceFromFavorites(placeId:self.place!.placeId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        self.favoritePlaceAddedObserver = ModelNotification.FavoritePlaceAdded.observe(callback: { (value) in
            DispatchQueue.main.async {
                self.myActivityIndicator.stopAnimating()
                if value != nil {
                    print("ViewControllerPlaceDetails : added favorite")
                    self.favoriteBtnOutlet.setImage(#imageLiteral(resourceName: "fav-full"), for: .normal)
                    Utils.presentAlert(title: "Place was added to favorites!", msg: self.place!.name, vc: self)
                }
                else {
                    print("ViewControllerPlaceDetails : not added favorite")
                    Utils.presentAlert(title: "Error add place favorites", msg: self.place!.name, vc: self)
                }
            }
        })
        
        self.favoritePlaceRemovedObserver = ModelNotification.FavoritePlaceRemoved.observe(callback: { (value) in
            DispatchQueue.main.async {
                self.myActivityIndicator.stopAnimating()
                if value != nil {
                    print("ViewControllerPlaceDetails : remove favorite")
                    self.favoriteBtnOutlet.setImage(#imageLiteral(resourceName: "fav-empty"), for: .normal)
                    Utils.presentAlert(title: "Place was removed from favorites!", msg: self.place!.name, vc: self)
                }
                else {
                    print("ViewControllerPlaceDetails : not remove favorite")
                    Utils.presentAlert(title: "Error remove place from favorites", msg: self.place!.name, vc: self)
                }
            }
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        ModelNotification.removeObserver(observer: self.favoritePlaceAddedObserver!)
        ModelNotification.removeObserver(observer: self.favoritePlaceRemovedObserver!)
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapController {
            let vc = segue.destination as! MapController
            vc.placeLat = self.place?.latitude
            vc.placeLng = self.place?.longitude
            vc.placeName = self.place?.name
            vc.placeCountry = self.place?.country
        }
    }
    
}

extension PlaceDetails: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(self.imagesScrollView.contentOffset.x/self.view.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
    
    func initScrollViewAndPageController(){
        self.imagesScrollView.delegate = self
        self.imagesScrollView.isPagingEnabled = true
        self.pageControl.numberOfPages = self.placeImages.count
        self.pageControl.currentPage = 0
        for (index,image) in self.placeImages.enumerated() {
            self.addImageToScrollView(image: image, index: index)
        }
    }
    
    func addImageToScrollView(image:UIImage,index: Int){
        DispatchQueue.main.async {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleToFill
            let xPosition = self.view.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.imagesScrollView.frame.width, height: self.imagesScrollView.frame.height)
            
            self.imagesScrollView.contentSize.width = self.imagesScrollView.frame.width * CGFloat(index+1)
            self.imagesScrollView.addSubview(imageView)
        }
    }
    
}
