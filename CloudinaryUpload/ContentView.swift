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
            
        }
        .sheet(isPresented: $isShowingSheet) {
            ImagePicker(selectedImage: $imageSelected, sourceType: choice == .camera ? .camera :  .photoLibrary)
        }
    }
    
    func uploadImage() {
        let config = CLDConfiguration(cloudName: "your_cloud_name", apiKey: "your_api_key", apiSecret: "your_api_secret")
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
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
