//
//  GameMenager.swift
//  Plantinhas
//
//  Created by Bruno Imai on 01/02/22.
//

import Foundation

class GameManager{
    
    var actualOxygen = 0.0
    
    var plantLimit = 8
    var spawnTime = 4.0
    var oxygenBoost = 1.0
    
    var oxygenBoostUpgradeValue = 10000.0
    var farmLimitUpgradeValue = 10000.0
    var seedSpawnUpgradeValue = 5000.0
    
    var gameScene : GameScene?
    
    var controller : GameViewController?
    
    var shop = Shop()
    
    var plantsDiscovered : [Plant] = []
    
    func checkNewPlants(_ newPlant : Plant) {
            let plantsAnalyzed = plantsDiscovered.filter {$0.name == newPlant.name}
        
            if plantsAnalyzed.isEmpty {
                plantsDiscovered.append(newPlant)
                print("Planta: ", newPlant.name, " descoberta!")
                shop.setPlantPrice(newPlant.name, newPlant.oxygeProduction * 100)
        }
    }
    
    static let shared = GameManager()
    
    private init(){}
    
//MARK: Data Persistence
    
    let userDefaults = UserDefaults.standard
    
    func save(_ content : Any, key: String) {
        userDefaults.set(content, forKey: key)
        print(key,": salvo")
    }
    
    func saveGame() {
        save(actualOxygen, key: "actualOxygen")
        
//        let encodedShop = try! NSKeyedArchiver.archivedData(withRootObject: shop, requiringSecureCoding: false)
//        save(encodedShop, key: "shop")
        
        let encodedPlantsDiscovered = try! NSKeyedArchiver.archivedData(withRootObject: plantsDiscovered, requiringSecureCoding: false)
        save(encodedPlantsDiscovered, key: "plantsDiscovered")
        
        let encodedPlantInScene = try! NSKeyedArchiver.archivedData(withRootObject: gameScene!.plantInScene, requiringSecureCoding: false)
        save(encodedPlantInScene, key: "plantsInScene")
        
        save(plantLimit, key: "plantLimit")
        save(spawnTime, key: "spawnTime")
        save(oxygenBoost, key: "oxygenBoost")
        
        save(shop.plantsValue, key: "plantsValue")
        save(shop.oxygenBoostUpgradeValue, key: "oxygenBoostUpgradeValue")
        save(shop.farmLimitUpgradeValue, key: "farmLimitUpgradeValue")
        save(shop.seedSpawnUpgradeValue, key: "seedSpawnUpgradeValue")
        
    }
    
}
