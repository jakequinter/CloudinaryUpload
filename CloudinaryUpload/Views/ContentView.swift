//
//  ContentView.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/24/23.
//


import SwiftUI

struct ContentView: View {
    @State private var isShowingAddFood = false
    
    let emojis = ["🍔", "🌮", "🍕", "🍲", "🍩", "🍦", "🍣", "🥐", "🫔", "🥖"]
    let percentages = [(0.2, 0.1), (0.8, 0.2), (0.5, 0.3), (0.02, 0.4), (0.3, 0.5), (0.7, 0.6), (0.1, 0.7), (0.9, 0.8), (0.28, 0.9), (0.65, 0.98)]
    
    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.5).edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ZStack {
                    ForEach(Array(zip(emojis, percentages)), id: \.0) { emoji, percentage in
                        Text(emoji)
                            .font(.system(size: geometry.size.width * 0.135))
                            .position(x: geometry.size.width * CGFloat(percentage.0), y: geometry.size.height * CGFloat(percentage.1))
                    }
                }
            }
            VStack {
                Spacer()
                Spacer()
                Spacer()
                
                Button("Add new food") {
                    isShowingAddFood = true
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.black)
                .cornerRadius(50)
                .font(.headline)
                
                Spacer()
            }
            .sheet(isPresented: $isShowingAddFood) {
                AddFoodView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
