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
    @FocusState var isInputActive: Bool
    
    
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
                    .focused($isInputActive)
                    .autocapitalization(.none)
                
                TextField("Restaurant url", text: $viewModel.food.link)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                    .focused($isInputActive)
                    .autocapitalization(.none)
                
                TextField("Jake rating", value: $viewModel.food.jakeRating, format: .number)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                    .keyboardType(.decimalPad)
                    .focused($isInputActive)
                
                TextField("Jen rating", value: $viewModel.food.jenRating, format: .number)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.secondary.opacity(0.5))
                    )
                    .keyboardType(.decimalPad)
                    .focused($isInputActive)
                
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
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button {
                    viewModel.addFood()
                } label: {
                    Text("Add")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                }
                .disabled(viewModel.disabled)
                .padding()
                .background(viewModel.disabled ? Color.accentColor.opacity(0.4) : Color.accentColor.opacity(1))
                .cornerRadius(.infinity)
                .foregroundColor(.white)
            }
            .padding()
            .navigationTitle("Add food")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
            .overlay(
                ZStack {
                    if viewModel.loading {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        LoadingView()
                            .frame(width: 300, height: 100)
                            .cornerRadius(20)
                    }
                }
            )
            
        }
        .sheet(isPresented: $isShowingSheet) {
            ImagePicker(selectedImage: viewModel.imageBinding, sourceType: choice == .camera ? .camera : .photoLibrary)
                .presentationCornerRadius(35)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showingError) {
            Button("OK") {
                viewModel.loading = false
                viewModel.showingError = false
            }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
