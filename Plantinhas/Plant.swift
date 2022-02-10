//
//  Plant.swift
//  Plantinhas
//
//  Created by Bruno Imai on 28/01/22.
//

import Foundation
import SpriteKit

class Plant: NSObject, NSCoding  {
    
    public let node : SKSpriteNode
    public let name : String
    public let oxygeProduction : Double
    
    init(name: String, oxygeProduction: Double) {
        self.name = name
        self.node = SKSpriteNode(imageNamed: name)
        self.node.name = name
        self.oxygeProduction = oxygeProduction
    }
    
    init(name: String, oxygeProduction: Double, node: SKSpriteNode) {
        self.name = name
        self.node = node
        self.node.name = name
        self.oxygeProduction = oxygeProduction
    }
    required convenience init(coder aDecoder: NSCoder) {
        let node = aDecoder.decodeObject(forKey: "node") as! SKSpriteNode
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let oxygeProduction = aDecoder.decodeDouble(forKey: "oxygeProduction")
        self.init(name: name, oxygeProduction: oxygeProduction, node: node)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(node, forKey: "node")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(oxygeProduction, forKey: "oxygeProduction")
    }
    
}
