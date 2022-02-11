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
    public var tinyDesc = "a"
    public var desc = ""
    
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
    
    func setDesc() {
        switch name {
        case "plant1":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant2":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant3":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant4":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant5":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant6":
            tinyDesc = "”nao mexe comigo naum meu filho”"
            desc = "Segundo estudos científicos, a especie ”Tomatus Doidus” surge de uma mutacao poderosa. Também conhecido por sua fúria, é uma planta importante para aqueles que desejam conquistar o planeta pois libera uma boa quantidade de Oxigenio devido seus acessos de raiva. /n Um ótimo aliado, porém, muito cuidado, voce nao vai querer ser vítima do Tomate Doido e sua fúria. "
        
        case "plant7":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant8":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        case "plant9":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
            
        case "plant10":
            tinyDesc = "coisinha"
            desc = "Coisonaaaaaaaaaaaaaa"
        
        default:
            tinyDesc = "deu ruim"
            desc = "deu ruim"
        }
    }
}
