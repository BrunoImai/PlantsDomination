//
//  GameMenager.swift
//  Plantinhas
//
//  Created by Bruno Imai on 01/02/22.
//

import Foundation
import UIKit

class GameManager{
    
    var actualOxygen = 0.0
    var carbonCredits = 0
    
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
    
    var newPlantVC : NewPlantPopUpViewController?
    
    func checkNewPlants(_ newPlant : Plant) {
            let plantsAnalyzed = plantsDiscovered.filter {$0.name == newPlant.name}
        
        if plantsAnalyzed.isEmpty {
                plantsDiscovered.append(newPlant)
                print("Planta: ", newPlant.name, " descoberta!")
                
                shop.setPlantOxygenPrice(newPlant.name, newPlant.oxygenProduction * 250)
                shop.setPlantCarbonPrice(newPlant.name, plantsDiscovered.count * 10)
                
                newPlantVC!.setPlantAchived(newPlant)
                controller?.show(newPlantVC!, sender: self)
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
        save(carbonCredits, key: "carbonCredits")
        
        let encodedPlantsDiscovered = try! NSKeyedArchiver.archivedData(withRootObject: plantsDiscovered, requiringSecureCoding: false)
        save(encodedPlantsDiscovered, key: "plantsDiscovered")
        
        let encodedPlantInScene = try! NSKeyedArchiver.archivedData(withRootObject: gameScene!.plantInScene, requiringSecureCoding: false)
        save(encodedPlantInScene, key: "plantsInScene")
        
        save(plantLimit, key: "plantLimit")
        save(spawnTime, key: "spawnTime")
        save(oxygenBoost, key: "oxygenBoost")
        
        save(shop.plantsOxygenValue, key: "plantsOxygenValue")
        save(shop.plantsCarbonValue, key: "plantsCarbonValue")
        save(shop.oxygenBoostUpgradeValue, key: "oxygenBoostUpgradeValue")
        save(shop.farmLimitUpgradeValue, key: "farmLimitUpgradeValue")
        save(shop.seedSpawnUpgradeValue, key: "seedSpawnUpgradeValue")
        
    }
    
}
