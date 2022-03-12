//
//  SpeedScene.swift
//  Plantinhas
//
//  Created by Bruno Imai on 11/03/22.
//

import UIKit
import SpriteKit

class SpeedScene: SKScene {
    
    var timer = Timer()
    
    var timeIncreased = 0.0
    
    var gameStarted = false
    
    weak var gameVC : SpeedSceneViewController?

    var plantInScene : [Plant] = []
    
    var touching = false
    
    private var currentNode: SKNode?
    
    private var background: SKSpriteNode?
    
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "background") as? SKSpriteNode
        background?.name = "background"
        background?.isUserInteractionEnabled = true
        background?.zPosition = -1000000000
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(seedSpawn),
                SKAction.wait(forDuration: 0.5)
            ])
        ))
        
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        timeIncreased += 0.1
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = -1
        let number =  numberFormatter.string(from: NSNumber(value: timeIncreased))!
        gameVC?.timerLabel.text = number
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        updatePosition()
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func touchDown(atPoint pos : CGPoint) {
        for plant in plantInScene {
            if plant.name == "seed" && plant.node.contains(pos) {
                spawnFromSeed(plant.node)
                removePlant(plant.node)
            }
        }
            
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let maxYtouch = (gameVC?.timerLabel.frame.maxY)! + (gameVC?.view.frame.height)!/2 - 150

        if pos.y < maxYtouch {
            if currentNode != nil && currentNode!.name != "seed" && currentNode!.name != "background"  {
                self.currentNode!.position = pos
                
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
            if currentNode != nil {
                for plant in plantInScene {
                    if currentNode!.contains(plant.node.position) && currentNode! != plant.node {
                        if plant.node.name == currentNode!.name &&
                            currentNode!.name != "seed" {
                        
                            collisionBetween(plant, currentNode!)
                            break
                        }
                    }
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
                touching = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.currentNode = nil
        touching = false
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.currentNode = nil
    }
    
    
    func seedSpawn() {
        
        if  plantInScene.count < 10 && !touching && gameStarted {
            
            let plant = Plant(name: "seed", oxygeProduction: 0)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            plant.node.position = CGPoint(x: actualX, y: actualY)
            
            plantInScene.append(plant)
                        
            addChild(plant.node)

        }
        
    }
    
    func spawnFromSeed(_ seed: SKNode) {
        if  plantInScene.count <= 10 {

            let plant = Plant(name: "Sprouty", oxygeProduction: 0.9)
            
            plant.node.position = seed.position
            
            plantInScene.append(plant)
            addChild(plant.node)
        }
    }
    
    func spawnPlant(plant: Plant) {
        if  plantInScene.count < GameManager.shared.plantLimit {
        
            let newPlant = Plant(name: plant.name, oxygeProduction: 0.0)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            newPlant.node.position = CGPoint(x: actualX, y: actualY)
            
            plantInScene.append(newPlant)
                        
            addChild(newPlant.node)
        }
    }
    
    
    func fusePlant(father: Plant) {
        
        let plantType = plantType(father.name)
        
        if plantType != "erro" {
        
            let oxygeProduction = 0.0
        
            let plant = Plant(name: plantType, oxygeProduction: oxygeProduction)
            
            plant.node.position = father.node.position
        
            plantInScene.append(plant)
            addChild(plant.node)
            playEffect("fuse", "wav")
            
        }
    }
    
    func collisionBetween(_ plant1: Plant, _ plantDragged: SKNode) {
        let plantType = plantType(plant1.name)
        
        if plantType != "Farmeradish" {
            removePlant(plant1.node)
            removePlant(plantDragged)
            fusePlant(father: plant1)
        } else {
            print("Finalizado em : ", timeIncreased, " segundos!")
            timer.invalidate()
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            let number =  numberFormatter.string(from: NSNumber(value: timeIncreased))!
            
            gameVC?.scoreLabel.text = number
            gameVC?.updateScore(with: timeIncreased)
            gameVC?.endView.isHidden = false
            gameVC?.endView.isUserInteractionEnabled = true
        }
        //FINALIZAR
        
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
                return "Sprouty"
            
            case "Sprouty":
                return "Happea"
            
            case "Happea":
                return "Bloom"
            
            case "Bloom":
                return "Puppea"
            
            case "Puppea":
                return "Manguspeaker"
            
            case "Manguspeaker":
                return "Madmato"
            
            case "Madmato":
                return "Farmushroom"
            
            case "Farmushroom":
                return "Farmeradish"
            
            case "Farmeradish":
                return "Melearner"
            
            case "Melearner":
                return "Pumpkazam"
            
            default:
                return "erro"
            }
    }
    
    func getYScale(_ pos : CGFloat) -> Double{
        return (pos / -(view?.frame.maxY)! + 1.0)
    }
    
    func playEffect(_ musicName : String, _ format: String) {
        var sfx: SKAudioNode!
        if let musicURL = Bundle.main.url(forResource: musicName, withExtension: format) {
            sfx = SKAudioNode(url: musicURL)
            sfx.autoplayLooped = false
            addChild(sfx)
            sfx.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run {
                       // this will start playing the pling once.
                    sfx.run(SKAction.play())
                   }
               ]))
        }
    }
}

