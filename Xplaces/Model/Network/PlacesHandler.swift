//
//  PlacesHandler.swift
//  Explaces
//
//  Created by Danielle Glazer on 18/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import Foundation
import UIKit


class PlacesHandler {
    
    
    let baseUrl = appKeys["server"]! + "places/"

    func getPlacesIdsList(callback:@escaping ([String]?)->Void) {
        print("PlacesHandler: getPlacesIdsList")
        let destinationUrl = self.baseUrl
        guard let url = URL(string:destinationUrl)
            else {
                print("PlacesHandler: getPlacesIdsList url error")
                callback(nil)
                return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let data = data {
                do{
                    print("PlacesHandler: getPlacesIdsList: got data");
                    let json = try JSONSerialization.jsonObject(with: data, options:[])
                    let placesIds = Utils.getPlacesIds(placesIdsJson: json as! [Dictionary<String, Any>])
                    callback(placesIds)
                } catch {
                    print("PlacesHandler: getPlacesIdsList: error")
                    callback(nil)
                }
            }
            else {
                print("PlacesHandler: getPlaceDescription: error")
                callback(nil)
            }
            }.resume()
    }
 
    func getPlaceDescription(placeName:String,callback:@escaping (String?)->Void){

        let dandelionApiKey = appKeys["dandelion"]
        let encodedPlaceName = placeName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print("encodedPlaceName : \(encodedPlaceName!)")
        let address = String("https://api.dandelion.eu/datatxt/nex/v1/?lang=en&text=" + encodedPlaceName! + "&include=abstract&token=" + dandelionApiKey!)
        
        print("PlacesHandler: getPlaceDescription");
        guard let url = URL(string:address)
            else {
                print("PlacesHandler:getPlaceDescription url error")
                callback(nil)
                return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let data = data {
                  do{
                print("PlacesHandler: getPlaceDescription: got data");
                let json = try JSONSerialization.jsonObject(with: data, options:[])
                let placeDescription = Utils.getPlaceDescription(placeDescriptionJson: json as! Dictionary<String, Any>)
                callback(placeDescription)
                  } catch {
                    print("PlacesHandler: getPlaceDescription: error")
                    callback(nil)
                }
            }
            else {
                print("PlacesHandler: getPlaceDescription: error")
                callback(nil)
            }
            }.resume()
    }
    
    
    
    func searchImage(image: UIImage, callback: @escaping (String?) -> Void) {
        print("PlacesHandler: searchImage")
        let destinationUrl = self.baseUrl + "find"
        guard let url = URL(string:destinationUrl)
            else {
                print("PlacesHandler: searchImage url error")
                callback(nil)
                return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = self.createDataBody(image: image, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data,response,error)in
            if let data = data {
                do{
                    print("PlacesHandler: searchImage: got data");
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:String]
                    let value = json["value"]!
                    callback(value)
                }
                catch{
                    print("PlacesHandler: searchImage: error")
                    print(error.localizedDescription)
                    callback(nil)
                    
                }
            }
            }.resume()
    }
    
    
    private func generateBoundary()->String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func createDataBody(image:UIImage, boundary: String) -> Data? {
        
        let lineBreak = "\r\n"
        var body = Data()
        guard let photoData = UIImageJPEGRepresentation(image, 0.8) else { return nil }
        let filename = self.getDocumentsDirectory().appendingPathComponent("img.png")
        try? photoData.write(to: filename)
        
        let key = "img"
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\(lineBreak)")
        body.append("Content-Type: image/png \(lineBreak + lineBreak)")
        body.append(photoData)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    
}


