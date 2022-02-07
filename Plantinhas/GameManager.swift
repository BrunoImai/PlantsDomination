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
    
    var gameScene : GameScene?
    
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
    
}
