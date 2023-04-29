//
//  AddFoodView.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/28/23.
//

import SwiftUI

enum Choice {
    case camera, photoLibrary
}

struct AddFoodView: View {
    @ObservedObject private var viewModel = AddFoodViewModel()
    @State private var choice: Choice = .photoLibrary
    @State private var isShowingSheet = false
   
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Restaurant name", text: $viewModel.food.restaurantName)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                TextField("Restaurant url", text: $viewModel.food.link)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                TextField("Jake rating", value: $viewModel.food.jakeRating, formatter: NumberFormatter())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                TextField("Jen rating", value: $viewModel.food.jenRating, formatter: NumberFormatter())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                
                HStack {
                    Button("Choose existing photo") {
                        choice = .photoLibrary
                        print("choice: \(choice)")
                        isShowingSheet = true
                    }
                    
                    Button {
                        choice = .camera
                        print("choice: \(choice)")
                        isShowingSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Snap photo")
                        }
                    }
                }
                
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button {
                    viewModel.addFood()
                } label: {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.noSelectedImage ? Color.black.gradient.opacity(0.1) : Color.black.gradient.opacity(1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 24)
                .disabled(viewModel.noSelectedImage)
            }
            .padding()
            .navigationTitle("Add food")
        }
        .sheet(isPresented: $isShowingSheet) {
            ImagePicker(selectedImage: viewModel.imageBinding, sourceType: choice == .camera ? .camera : .photoLibrary)
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
