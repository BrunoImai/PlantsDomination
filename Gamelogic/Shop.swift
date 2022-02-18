//
//  Shop.swift
//  Plantinhas
//
//  Created by Bruno Imai on 01/02/22.
//

import Foundation

class Shop: NSObject {
    
    var plantsValue = [String: Double]()
    
    var oxygenBoostUpgradeValue = 10000.0
    var farmLimitUpgradeValue = 10000.0
    var seedSpawnUpgradeValue = 5000.0
    
    func setPlantPrice(_ plantName : String, _ price : Double) {
        plantsValue[plantName] = price
        refreshShop()
    }
    
    func updatePlantPrice(_ plantName : String, _ oldPrice : Double) {
        plantsValue[plantName] = oldPrice + oldPrice / 5
        refreshShop()
    }
    
    func seedSpawnTimeUpgrade() {
        let currentOxygen = GameManager.shared.actualOxygen
        if currentOxygen >= seedSpawnUpgradeValue {
            
            GameManager.shared.actualOxygen -= seedSpawnUpgradeValue
            
            if GameManager.shared.spawnTime > 1 {
                GameManager.shared.spawnTime -= 0.5
                seedSpawnUpgradeValue = setSeedSpawnUpgradeValue()
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Oxigenio insuficiente")
        }
    }
    
    func farmLimitUpgrade() {
        let currentOxygen = GameManager.shared.actualOxygen
        if currentOxygen >= farmLimitUpgradeValue {
            
            GameManager.shared.actualOxygen -= farmLimitUpgradeValue
            
            if GameManager.shared.oxygenBoost < 500 {
                GameManager.shared.plantLimit += 1
                farmLimitUpgradeValue = setFarmLimitUpgradeValue(GameManager.shared.plantLimit)
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Oxigenio insuficiente")
        }
        
    }
    
    func oxygenBoostUpgrade() {
        let currentOxygen = GameManager.shared.actualOxygen
        if currentOxygen >= oxygenBoostUpgradeValue {
            
            GameManager.shared.actualOxygen -= oxygenBoostUpgradeValue
            
            if GameManager.shared.oxygenBoost <= 1.75 {
                GameManager.shared.oxygenBoost += 0.25
                oxygenBoostUpgradeValue = setOxygenBoostUpgradeValue()
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Oxigenio insuficiente")
        }
        
    }
    
    func refreshShop() {
        GameManager.shared.shop = self
    }
    
    
    func setFarmLimitUpgradeValue( _ farmLimit: Int) -> Double{
        switch farmLimit {
            
            case 9:
            return 25000
            
            case 10:
            return 100000
            
            case 11:
            return 500000
            
            case 12:
            return 2000000
            
            case 13:
            return 10000000
            
            case 14:
            return 50000000
            
            case 15:
            return 1000000000
            
            default:
            return 0.0
            }
    }
    
    func setSeedSpawnUpgradeValue() -> Double{
        switch GameManager.shared.spawnTime {
            
            case 4.5:
            return 100000
            
            case 4:
            return 500000
            
            case 3.5:
            return 2000000
            
            case 3:
            return 10000000
            
            case 2.5:
            return 50000000
            
            case 2:
            return 1000000000
            
            case 1.5:
            return 1000000000
        
            default:
            return 0.0
            }
    }
    
    func setOxygenBoostUpgradeValue() -> Double{
        switch GameManager.shared.oxygenBoost {
            
        case 0.25:
            return 100000
            
        case 0.50:
            return 500000
            
        case 0.75:
            return 2000000
            
            case 1:
            return 10000000
            
        case 1.25:
            return 50000000
            
        case 1.5:
            return 1000000000
            
        case 1.75:
            return 1000000000
        
            default:
            return 0.0
            }
    }
    
    override init(){
        
    }
    
}
