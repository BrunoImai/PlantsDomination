//
//  GameScene.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let defaults = UserDefaults.standard
    
    weak var viewController : GameViewController?
    
    var plantInScene : [Plant] = []
    
    private var currentNode: SKNode?
    private var background: SKSpriteNode?
    
    var backgroundMusic: SKAudioNode!

    override func didMove(to view: SKView) {
        
        background = self.childNode(withName: "background1") as? SKSpriteNode
        background?.name = "background"
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
                SKAction.run(reloadCollectionView),
                SKAction.wait(forDuration: 1)
            ])
        ))
        
        if defaults.bool(forKey: "First Launch happend") == true {
            print("Segundo uso")
            
            loadGame()
            
        } else {
            GameManager.shared.save(true, key: "First Launch happend")
            print("Primeiro uso")

        }
        
//        if let musicURL = Bundle.main.url(forResource: "musicFarm", withExtension: "mp3") {
//            backgroundMusic = SKAudioNode(url: musicURL)
//            addChild(backgroundMusic)
//        }
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let maxYtouch = (viewController?.oxygenNumberLabel.frame.maxY)! + (viewController?.view.frame.height)!/2 - 45

        if pos.y < maxYtouch {
            if currentNode != nil && currentNode!.name != "seed" && currentNode!.name != "background"  {
                self.currentNode!.position = pos
                print(currentNode!.name!)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
            if currentNode != nil {
                for plant in plantInScene {
                    if currentNode!.contains(plant.node.position) && currentNode! != plant.node {
                        if plant.node.name == currentNode!.name && currentNode!.name != "seed" {
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
    
    func reloadCollectionView( ) {
        viewController?.shopCollectionView.reloadData()
        viewController?.pediaCollectionView.reloadData()
    }
    
    //MARK: Plant Menagement
    
    func seedSpawn() {
        
        if  plantInScene.count < GameManager.shared.plantLimit {
            
            let plant = Plant(name: "seed", oxygeProduction: 0)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            plant.node.position = CGPoint(x: actualX, y: actualY)
            
            plant.setDesc()
            
            plantInScene.append(plant)
                        
            addChild(plant.node)

        }
    }
    func spawnFromSeed(_ seed: SKNode) {
        if  plantInScene.count <= GameManager.shared.plantLimit {

            let plant = Plant(name: "Brotinho", oxygeProduction: 1.1)
            
            plant.node.position = seed.position
            plant.setDesc()
            
            GameManager.shared.checkNewPlants(plant)
            
            plantInScene.append(plant)
            addChild(plant.node)
        }
    }
    
    func spawnPlant(plant: Plant) {
        if  plantInScene.count < GameManager.shared.plantLimit {
        
            let newPlant = Plant(name: plant.name, oxygeProduction: plant.oxygenProduction)
            
            let actualY = random (min: (background?.frame.minY ?? 0) + 250, max: (background?.frame.maxY ?? 0) - 350)
            
            let actualX = random (min: (background?.frame.minX ?? 0) + 120, max: (background?.frame.maxX ?? 0) - 120)
            
            newPlant.node.position = CGPoint(x: actualX, y: actualY)
            
            newPlant.setDesc()
            
            plantInScene.append(newPlant)
                        
            addChild(newPlant.node)
        }
    }
    
    func fusePlant(father: Plant) {
        
            let plantType = plantType(father.name)
        
            let oxygeProduction = plantValue(father)
        
            let plant = Plant(name: plantType, oxygeProduction: oxygeProduction)
        
            plant.setDesc()
            
            plant.node.position = father.node.position
        
            GameManager.shared.checkNewPlants(plant)
        
            plantInScene.append(plant)
            addChild(plant.node)
            playEffect("fuse", "wav")
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
                return "Brotinho"
            
            case "Brotinho":
                return "Brotervilha"
            
            case "Brotervilha":
                return "Florervilha"
            
            case "Florervilha":
                return "Plantapet"
            
            case "Plantapet":
                return "Mangandante"
            
            case "Mangandante":
                return "Doidomate"
            
            case "Doidomate":
                return "Fazengumelo"
            
            case "Fazengumelo":
                return "Cultivanete"
            
            case "Cultivanete":
                return "Melanprendiz"
            
            case "Melanprendiz":
                return "Magib??bora"
            
            default:
                return "plant10"
            }
    }
    
   
    
    func plantValue( _ father: Plant) -> Double {

        return father.oxygenProduction * 2.1 * GameManager.shared.oxygenBoost

    }
    
    func oxygenNumber() {
        for plant in plantInScene {
            GameManager.shared.actualOxygen += plant.oxygenProduction
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        let number =  numberFormatter.string(from: NSNumber(value: GameManager.shared.actualOxygen))
        viewController?.oxygenNumberLabel.text = number
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
    
    func loadGame() {
        GameManager.shared.actualOxygen = defaults.object(forKey:"actualOxygen") as! Double
        
        let decodedPlantsDiscovered = defaults.data(forKey: "plantsDiscovered")
        let plants = NSKeyedUnarchiver.unarchiveObject(with: decodedPlantsDiscovered!) as! [Plant]
        
        for plant in plants {
            plant.setDesc()
            GameManager.shared.plantsDiscovered.append(plant)
        }
        
        let decodedPlantsInScene = defaults.data(forKey: "plantsInScene")
        GameManager.shared.gameScene?.plantInScene = NSKeyedUnarchiver.unarchiveObject(with: decodedPlantsInScene!) as! [Plant]
        
        GameManager.shared.plantLimit = defaults.object(forKey: "plantLimit") as! Int
        GameManager.shared.spawnTime = defaults.object(forKey:"spawnTime") as! Double
        GameManager.shared.oxygenBoost = defaults.object(forKey:"oxygenBoost") as! Double
        GameManager.shared.oxygenBoostUpgradeValue = defaults.object(forKey: "oxygenBoostUpgradeValue") as! Double
        GameManager.shared.seedSpawnUpgradeValue = defaults.object(forKey: "seedSpawnUpgradeValue") as! Double
        GameManager.shared.oxygenBoostUpgradeValue = defaults.object(forKey: "farmLimitUpgradeValue") as! Double
        
        GameManager.shared.shop.plantsValue = defaults.object(forKey: "plantsValue") as! [String : Double]
        
        for plant in GameManager.shared.gameScene!.plantInScene {
            addChild(plant.node)
            plant.setDesc()
            print(plant.tinyDesc)
        }
        
    }
}



