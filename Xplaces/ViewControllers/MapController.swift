//
//  MapController.swift
//  Xplaces
//
//  Created by Danielle Glazer on 19/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController , CLLocationManagerDelegate {
    
    
    var placeLat:Double?
    var placeLng:Double?
    var placeName:String?
    var placeCountry:String?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: self.placeLat!, longitude: self.placeLng!)
        
        let regionRadius: CLLocationDistance = 5000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        let mapAnnotation = MapAnnotation(title: self.placeCountry!,
                                          subtitle: self.placeName!,
                                          coordinate: CLLocationCoordinate2D(latitude: self.placeLat!, longitude: self.placeLng!))
        self.mapView.addAnnotation(mapAnnotation)
        
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let locValue: CLLocationCoordinate2D = location.coordinate
            let distance = self.getDistanceUserToPlace(location:locValue)
            self.distanceLabel.text = "Distance: " + String(distance) + " km"
        }
       
    }
    
    private func getDistanceUserToPlace(location: CLLocationCoordinate2D) -> Double {
        let R : Double = 6371
        let userLong = location.longitude
        let userLat = location.latitude
        
        let placeLongitude = self.placeLng
        let placeLatitude = self.placeLat
        
        let dLong = self.degToRad(deg:(userLong - placeLongitude!))
        let dLat = self.degToRad(deg:(userLat - placeLatitude!))
        
        let dLatHalf = dLat/2
        let dLongHalf = dLong/2
        let a = sin(dLatHalf) * sin(dLatHalf) + cos(self.degToRad(deg: placeLatitude!)) * cos(self.degToRad(deg: userLat)) * sin(dLongHalf) * sin(dLongHalf)
        
        let square1 = a.squareRoot()
        let difference :Double = 1-a
        let square2 = difference.squareRoot()
        let c = 2 * atan2(square1,square2)
      
        let distance = c * R
        let r = Double(round(100*distance)/100)
        return r
    }
    
    private func degToRad(deg:Double)->Double {
        return deg * .pi / 180.0
    }
    
    
    private class MapAnnotation:NSObject,MKAnnotation{
        var title:String?
        var subtitle: String?
        var coordinate: CLLocationCoordinate2D
        
        init(title:String, subtitle:String,coordinate:CLLocationCoordinate2D){
            self.title = title
            self.subtitle = subtitle
            self.coordinate = coordinate
            
        }
    }
    
    
    
    
}
