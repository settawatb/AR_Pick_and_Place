//
//  Model_products.swift
//  AR_test
//
//  Created by Kisses MJ on 26/12/2566 BE.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                // Handle error
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue: { modelEntity in
                // Get modelEntity
                self.modelEntity = modelEntity
                print("DEBUG: Successfully loaded modelEntity for modelName: \(self.modelName)")
            })
        
    }
}
