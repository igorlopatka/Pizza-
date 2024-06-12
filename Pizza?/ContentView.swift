//
//  ContentView.swift
//  Pizza?
//
//  Created by Igor Łopatka on 11/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text(viewModel.detectedLabel)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                
                if viewModel.isPizza {
                    Text("It's a pizza!")
                        .font(.title)
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
