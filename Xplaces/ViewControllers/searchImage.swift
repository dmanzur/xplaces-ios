//
//  searchImage.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit


class searchImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var searchImageOutlet: UIButton!
    @IBOutlet weak var imagePic: UIImageView!
    
    var placeImages : [UIImage]?
    var place : Place?
    lazy var myActivityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePic.layer.borderWidth = 1
        self.imagePic.layer.borderColor = UIColor.blue.cgColor
        self.searchImageOutlet.isEnabled = false
        
    }
    
    
    @IBAction func chooseImageBtn(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imagePic.image = image
        self.searchImageOutlet.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchImageBtn(_ sender: Any) {
        
        if let image = self.imagePic.image {
            self.myActivityIndicator.create(vc: self)
            self.myActivityIndicator.startAnimating()
            PlacesService.sharedInstance.searchImage(image: image) { (place) in
                DispatchQueue.main.async {
                    if place != nil {
                        self.place = place
                        PlacesService.sharedInstance.getGooglePlaceImages(placeId: place!.placeId, callback: {(images) in
                            self.myActivityIndicator.stopAnimating()
                            if let images = images {
                                self.placeImages = images
                                self.performSegue(withIdentifier: "searchImageSegue", sender: self)
                            } else {
                                Utils.presentAlert(title: "Place found! but..", msg: "place images not found", vc: self)
                            }
                        })
                    }
                    else {
                        self.myActivityIndicator.stopAnimating()
                        Utils.presentAlert(title: "Place not found", msg: "Try sharper photo", vc: self)
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PlaceDetails {
            let vc = segue.destination as! PlaceDetails
            vc.place = self.place!
            vc.placeImages = self.placeImages!
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.imagePic.image = #imageLiteral(resourceName: "image-placeholder")
        self.searchImageOutlet.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }

    
    
    
}
