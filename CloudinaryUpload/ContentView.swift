//
//  ContentView.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/24/23.
//

import Cloudinary
import SwiftUI
import UIKit

enum Choice {
    case camera, photoLibrary
}

struct ContentView: View {
    @State var imageSelected = UIImage()
    @State private var isShowingSheet = false
    @State private var choice: Choice = .photoLibrary
    
    var body: some View {
        VStack {
            Button {
                self.choice = .camera
                self.isShowingSheet = true
            } label: {
                HStack {
                    Image(systemName: "camera")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Snap photo")
                }
            }
            
            Button("Choose existing photo") {
                self.choice = .photoLibrary
                self.isShowingSheet = true
            }
            Button("Upload Image") {
                uploadImage()
            }
            Button("Add food") {
                addFood()
            }
            
        }
        .sheet(isPresented: $isShowingSheet) {
            ImagePicker(selectedImage: $imageSelected, sourceType: choice == .camera ? .camera :  .photoLibrary)
        }
    }
    
    func uploadImage() {
        guard let path = Bundle.main.path(forResource: "env", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil),
              let myDictionary = plist as? [String: String],
              let cloudName = myDictionary["CLOUDINARY_CLOUD_NAME"],
              let apiKey = myDictionary["CLOUDINARY_API_KEY"],
              let apiSecret = myDictionary["CLOUDINARY_API_SECRET"] else {
            fatalError("Environment variables not found")
        }
        
        let config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
        let cloudinary = CLDCloudinary(configuration: config)
        
        let data = imageSelected.jpegData(compressionQuality: 0.8)!
        let params = CLDUploadRequestParams()
        
        cloudinary.createUploader().signedUpload(data: data, params: params, progress: nil) { result, error in
            if let error = error {
                print("Error uploading image: \(error)")
            } else if let result = result {
                print("Image uploaded successfully: \(result.secureUrl ?? "")")
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
        
        let url = URL(string: "http://localhost:3000/api/food")!
        let data = Food(restaurantName: "Example Restaurant", jakeRating: 4, jenRating: 5, link: "https://example.com", image: "https://example.com/image.jpg")
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
