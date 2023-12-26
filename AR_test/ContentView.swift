//
//  ContentView.swift
//  AR_test
//
//  Created by Kisses MJ on 26/12/2566 BE.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var models: [String] = ["robot_walk","toy_biplane","toy_drummer"]
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            
            ModelPickerView(models: self.models)
            
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    var models: [String]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(self.models.indices, id: \.self) { index in
                    Button(action: {
                        print("DEBUG: selected model with name: \(self.models[index])")
                    }) {
                        Image(uiImage: UIImage(named: self.models[index])!)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
        
    }
}



#Preview {
    ContentView()
}
