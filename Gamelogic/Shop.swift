//
//  Shop.swift
//  Plantinhas
//
//  Created by Bruno Imai on 01/02/22.
//

import Foundation

class Shop: NSObject {
    
    var plantsOxygenValue = [String: Double]()
    var plantsCarbonValue = [String: Int]()
    
    var oxygenBoostUpgradeValue = 10000.0
    var farmLimitUpgradeValue = 10000.0
    var seedSpawnUpgradeValue = 5000.0
    
    var oxygenBoostUpgradeCarbonValue = 1000
    var farmLimitUpgradeCarbonValue = 1000
    var seedSpawnUpgradeCarbonValue = 500
    
    func setPlantOxygenPrice(_ plantName : String, _ price : Double) {
        plantsOxygenValue[plantName] = price
        refreshShop()
    }
    
    func setPlantCarbonPrice(_ plantName : String, _ price : Int) {
        plantsCarbonValue[plantName] = price
        refreshShop()
    }

    
    func updatePlantOxygenPrice(_ plantName : String, _ oldPrice : Double) {
        plantsOxygenValue[plantName] = oldPrice + oldPrice / 5
        refreshShop()
    }
    
    func updatePlantCarbonPrice(_ plantName : String, _ oldPrice : Int) {
        plantsCarbonValue[plantName] = oldPrice + oldPrice / 5
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
    
    func seedSpawnTimeCarbonUpgrade() {
        let currentCarbon = GameManager.shared.carbonCredits
        if currentCarbon >= seedSpawnUpgradeCarbonValue {
            
            GameManager.shared.carbonCredits -= seedSpawnUpgradeCarbonValue
            
            if GameManager.shared.spawnTime > 1 {
                GameManager.shared.spawnTime -= 0.5
                seedSpawnUpgradeCarbonValue = setSeedSpawnUpgradeCarbonValue()
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Créditos de carbono insuficiente")
        }
    }
    
    func farmLimitUpgrade() {
        let currentOxygen = GameManager.shared.actualOxygen
        if currentOxygen >= farmLimitUpgradeValue {
            
            GameManager.shared.actualOxygen -= farmLimitUpgradeValue
            
            if GameManager.shared.plantLimit <= 30 {
                GameManager.shared.plantLimit += 1
                farmLimitUpgradeValue = setFarmLimitUpgradeValue(GameManager.shared.plantLimit)
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Oxigenio insuficiente")
        }
        
    }
    
    func farmLimitCarbonUpgrade() {
        let carbonCredits = GameManager.shared.carbonCredits
        if carbonCredits >= farmLimitUpgradeCarbonValue {
            
            GameManager.shared.carbonCredits -= farmLimitUpgradeCarbonValue
            
            if GameManager.shared.plantLimit <= 30 {
                GameManager.shared.plantLimit += 1
                farmLimitUpgradeCarbonValue = setFarmLimitUpgradeCarbonValue(GameManager.shared.plantLimit)
                refreshShop()
                GameManager.shared.gameScene?.playEffect("buy", "wav")
            }
        }else {
            print("Créditos de carbono insuficiente")
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
    
    func oxygenBoostCarbonUpgrade() {
        let carbonCredits = GameManager.shared.carbonCredits
        if carbonCredits >= oxygenBoostUpgradeCarbonValue {
            
            GameManager.shared.carbonCredits -= oxygenBoostUpgradeCarbonValue
            
            if GameManager.shared.oxygenBoost <= 1.75 {
                GameManager.shared.oxygenBoost += 0.25
                oxygenBoostUpgradeCarbonValue = setOxygenBoostUpgradeCarbonValue()
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
    
    func setFarmLimitUpgradeCarbonValue( _ farmLimit: Int) -> Int{
        switch farmLimit {
            
            case 9:
            return 2500
            
            case 10:
            return 3000
            
            case 11:
            return 3500
            
            case 12:
            return 4000
            
            case 13:
            return 5500
            
            case 14:
            return 6000
            
            case 15:
            return 6500
            
            default:
            return 0
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
    
    func setSeedSpawnUpgradeCarbonValue() -> Int {
        switch GameManager.shared.spawnTime {
            
            case 4.5:
            return 2000
            
            case 4:
            return 2500
            
            case 3.5:
            return 3000
            
            case 3:
            return 3500
            
            case 2.5:
            return 4000
            
            case 2:
            return 4500
            
            case 1.5:
            return 5000
        
            default:
            return 0
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
    func setOxygenBoostUpgradeCarbonValue() -> Int{
        switch GameManager.shared.oxygenBoost {
            
        case 0.25:
            return 1000
            
        case 0.50:
            return 1500
            
        case 0.75:
            return 2000
            
            case 1:
            return 2300
            
        case 1.25:
            return 2600
            
        case 1.5:
            return 2900
            
        case 1.75:
            return 3200
        
            default:
            return 0
            }
    }
}
