//
//  LoadingView.swift
//  CloudinaryUpload
//
//  Created by Jake Quinter on 4/29/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            // ProgressView modal
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Uploading...")
                    .foregroundColor(.secondary)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
