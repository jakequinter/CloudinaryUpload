//
//  ContentView.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/24/23.
//


import SwiftUI


enum Choice {
    case camera, photoLibrary
}

struct ContentView: View {
    @State private var isShowingAddFood = false
    
    var body: some View {
        VStack {
            Button("New food") {
                isShowingAddFood = true
            }
        }
        .sheet(isPresented: $isShowingAddFood) {
            AddFoodView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
