//
//  Plant.swift
//  Plantinhas
//
//  Created by Bruno Imai on 28/01/22.
//

import Foundation
import SpriteKit

class Plant {
    
    public let node : SKSpriteNode
    public let name : String
    public let oxygeProduction : Double
    
    init(name: String, oxygeProduction: Double) {
        self.name = name
        self.node = SKSpriteNode(imageNamed: name)
        self.node.name = name
        self.oxygeProduction = oxygeProduction
    }
    
}
