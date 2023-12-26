//
//  ContentView.swift
//  AR_test
//
//  Created by Kisses MJ on 26/12/2566 BE.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    
    private var models: [String] = {
            let filemanager = FileManager.default
            guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath:path) else {
                return []
            }
            var availableModels: [String] = []
            for filename in files where filename.hasSuffix("usdz") {
                let modelName = filename.replacingOccurrences(of:".usdz", with: "")
                availableModels.append(modelName)
            }
            return availableModels
        }()
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
                
            } else {
                ModelPickerView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, models: self.models)
            }
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = self.modelConfirmedForPlacement {
            print("DEBUG: adding model to scene - \(modelName)")
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
    
}

struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    
    
    var models: [String]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(self.models.indices, id: \.self) { index in
                    Button(action: {
                        print("DEBUG: selected model with name: \(self.models[index])")
                        
                        self.selectedModel = self.models[index]
                        self.isPlacementEnabled = true
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

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedForPlacement: String?
    
    var body: some View {
        HStack {
            // Cancel Button
            Button(action: {
                print("DEBUG: model placement canceled.")
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            // Confirm Button
            
            Button(action: {
                print("DEBUG: model placement confirmed.")
                
                self.modelConfirmedForPlacement = self.selectedModel
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}



#Preview {
    ContentView()
}
