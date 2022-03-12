//
//  World.swift
//  Plantinhas
//
//  Created by Bruno Imai on 08/03/22.
//

import Foundation
import SceneKit

class WorldNode: SCNNode {
    
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 1)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "worldTexture")
        self.geometry?.firstMaterial?.specular.contents = UIImage(named: "Specular")
        self.geometry?.firstMaterial?.emission.contents = UIImage(named: "Emission")
        self.geometry?.firstMaterial?.shininess = 50
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
