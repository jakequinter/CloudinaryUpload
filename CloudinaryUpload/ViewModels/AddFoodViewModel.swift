//
//  AddFoodViewModel.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/28/23.
//

import Cloudinary
import Foundation
import SwiftUI
import UIKit

class AddFoodViewModel: ObservableObject {
    
    @Published var food = Food(restaurantName: "", jakeRating: 0, jenRating: 0, link: "", image: "")
    @Published var image: UIImage?
    @Published var showingError = false
    @Published var errorMessage = ""
    
    var imageBinding: Binding<UIImage> {
        Binding<UIImage>(
            get: { self.image ?? UIImage() },
            set: { self.image = $0 }
        )
    }
    
    var noSelectedImage: Bool {
        image == nil
    }
    
    func uploadImage(completion: @escaping (String?) -> Void) {
        guard let path = Bundle.main.path(forResource: "env", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil),
              let myDictionary = plist as? [String: String],
              let cloudName = myDictionary["CLOUDINARY_CLOUD_NAME"],
              let apiKey = myDictionary["CLOUDINARY_API_KEY"],
              let apiSecret = myDictionary["CLOUDINARY_API_SECRET"],
              let uploadPreset = myDictionary["CLOUDINARY_UPLOAD_PRESET"] else {
            fatalError("Environment variables not found")
        }
        guard let image = self.image,
              let data = image.jpegData(compressionQuality: 0.8) else {
            print("ERROR: handle me")
            return
        }
        
        let config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
        let cloudinary = CLDCloudinary(configuration: config)
        
        let params = CLDUploadRequestParams()
        params.setUploadPreset(uploadPreset)
        
        
        cloudinary.createUploader().signedUpload(data: data, params: params, progress: nil) { result, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else if let result = result {
                completion(result.secureUrl)
            }
        }
    }
    
    
    func addFood() {
        guard let path = Bundle.main.path(forResource: "env", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil),
              let myDictionary = plist as? [String: String],
              let token = myDictionary["TOKEN"] else {
            fatalError("Environment variables not found")
        }
        
        do {
            self.uploadImage { secureUrl in
                guard let secureUrl = secureUrl else {
                    print("No valid image")
                    return
                }
                
                let url = URL(string: "https://jakequinter.io/api/food")!
                let data = Food(restaurantName: self.food.restaurantName, jakeRating: self.food.jakeRating, jenRating: self.food.jenRating, link: self.food.link, image: secureUrl)
                let jsonData = try! JSONEncoder().encode(data)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("\(token)", forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                    } else if let data = data {
                        do {
                            let result = try JSONDecoder().decode(Food.self, from: data)
                            print("Result: \(result)")
                        } catch let error {
                            print("Error decoding response: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
