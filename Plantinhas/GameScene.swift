//
//  GameScene.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var viewController : GameViewController?
    
    var plantInScene : [Plant] = []
    
    private var currentNode: SKNode?
    private var background: SKSpriteNode?

    override func didMove(to view: SKView) {
        
        background = self.childNode(withName: "background1") as? SKSpriteNode
        background?.isUserInteractionEnabled = true
        background?.zPosition = -1000000000
        
        GameManager.shared.gameScene = self
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(seedSpawn),
                SKAction.wait(forDuration: GameManager.shared.spawnTime)
            ])
        ))
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(oxygenNumber),
                SKAction.wait(forDuration: 1)
            ])
        ))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        var nodeName = currentNode?.name
        nodeName?.removeLast()
        let maxYtouch = (viewController?.oxygenNumberLabel.frame.maxY)! + (viewController?.view.frame.height)!/2 - 45
        print(maxYtouch)
        print(pos.y)
        if pos.y < maxYtouch {
            if currentNode != nil && (nodeName == "plant" || nodeName == "plant1"){
                self.currentNode!.position = pos
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
            if currentNode != nil {
                for plant in plantInScene {
                    if currentNode!.contains(plant.node.position) && currentNode! != plant.node {
                        if plant.name == currentNode!.name && currentNode!.name != "seed" {
                            collisionBetween(plant, currentNode!)
                            break
                        }
                    }
                }
                if currentNode!.name == "seed" && ((currentNode?.contains(pos)) != nil) {
                    spawnFromSeed(currentNode!)
                    removePlant(currentNode!)
                }
            }
            self.currentNode = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                self.currentNode = node
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.currentNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.currentNode = nil
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        updatePosition()
        viewController?.updateShopUI()
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //MARK: Plant Menagement
    
    func seedSpawn() {
        
        if  plantInScene.count < GameManager.shared.plantLimit {
            
            let plant = Plant(name: "seed", oxygeProduction: 0)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            plant.node.position = CGPoint(x: actualX, y: actualY)
            
            plantInScene.append(plant)
                        
            addChild(plant.node)

        }
    }
    func spawnFromSeed(_ seed: SKNode) {
        if  plantInScene.count <= GameManager.shared.plantLimit {
            let plant = Plant(name: "plant1", oxygeProduction: 1.3)
            plant.node.position = seed.position
        
            GameManager.shared.checkNewPlants(plant)
            
            plantInScene.append(plant)
            addChild(plant.node)
        }
    }
    
    func spawnPlant(plant: Plant) {
        if  plantInScene.count < GameManager.shared.plantLimit {
        
            let newPlant = Plant(name: plant.name, oxygeProduction: plant.oxygeProduction)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            newPlant.node.position = CGPoint(x: actualX, y: actualY)
            
            plantInScene.append(newPlant)
                        
            addChild(newPlant.node)
        }
    }
    
    func fusePlant(father: Plant) {
        
            let plantType = plantType(father.name)
        
            let oxygeProduction = plantValue(father)
        
            let plant = Plant(name: plantType, oxygeProduction: oxygeProduction)
            
            plant.node.position = father.node.position
        
            GameManager.shared.checkNewPlants(plant)
        
            plantInScene.append(plant)
            addChild(plant.node)
            
    }
    
    func collisionBetween(_ plant1: Plant, _ plantDragged: SKNode) {
            
        removePlant(plant1.node)
        removePlant(plantDragged)
            
        fusePlant(father: plant1)
    }
    
    func removePlant(_ plantNode: SKNode) {
        plantNode.removeFromParent()
        plantInScene.removeAll { $0.node == plantNode }
    }
    
    func updatePosition() {
        for plant in plantInScene {
            plant.node.zPosition = -plant.node.frame.midY
            plant.node.setScale(getYScale((plant.node.position.y)))
        }
    }
    
    
    func plantType( _ plantName: String) -> String {
        switch plantName {
            
            case "seed":
                return "plant1"
            
            case "plant1":
                return "plant2"
            
            case "plant2":
                return "plant3"
            
            case "plant3":
                return "plant4"
            
            case "plant4":
                return "plant5"
            
            case "plant5":
                return "plant6"
            
            case "plant6":
                return "plant7"
            
            case "plant7":
                return "plant8"
            
            case "plant8":
                return "plant9"
            
            case "plant9":
                return "plant10"
            
            default:
                return "plant10"
            }
    }
    
   
    
    func plantValue( _ father: Plant) -> Double {
        return father.oxygeProduction * 3.2 * GameManager.shared.oxygenBoost
    }
    
    func oxygenNumber() {
        for plant in plantInScene {
            GameManager.shared.actualOxygen += plant.oxygeProduction
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        let number =  numberFormatter.string(from: NSNumber(value: GameManager.shared.actualOxygen))
        viewController?.oxygenNumberLabel.text = number
    }
    
    func getYScale(_ pos : CGFloat) -> Double{
        return (pos / -(view?.frame.maxY)! + 1.0)
    }
}



