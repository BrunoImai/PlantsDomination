//
//  plantCollectionViewCell.swift
//  Plantinhas
//
//  Created by Bruno Imai on 03/02/22.
//

import UIKit

class plantCollectionViewCell: UICollectionViewCell {

    var plantInCell : Plant? = nil

    
    @IBOutlet weak var maxWidthLayoutConstraint: NSLayoutConstraint!
    
    var maxWidth : CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {return}
            maxWidthLayoutConstraint.constant = maxWidth
        }
    }
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameOutlet: UILabel!
    @IBOutlet weak var oxygenPrice: UILabel!
    @IBOutlet weak var carbonPrice: UILabel!
    @IBOutlet weak var buyButtonOxygen: UIButton!
    @IBOutlet weak var buyButtonCarbon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plantImage.image = nil
        plantNameOutlet.text = nil
        oxygenPrice.text = nil
        carbonPrice.text = nil
        
        // colocar cores fonte etc
        // Setar coisas que mudam para nulo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plantImage.image = nil
        plantNameOutlet.text = nil
        oxygenPrice.text = nil
        carbonPrice.text = nil
        // Colocar tudo nulo dnv as coisas do awake from inib
    }

    func setup(_ plantIndex: Int) {
        let plant = GameManager.shared.plantsDiscovered[plantIndex]
        plantInCell = plant
        plantImage.image = UIImage.init(named: plant.name)
        plantNameOutlet.text = plant.name
        
        let plantOxygenPrice = GameManager.shared.shop.plantsOxygenValue[plant.name]!
        oxygenPrice.text = formatNumber(plantOxygenPrice)
        updateUIOxygenBuyButton(plantOxygenPrice, buyButtonOxygen)

        let plantCarbonPrice = GameManager.shared.shop.plantsCarbonValue[plant.name]!
        carbonPrice.text = formatNumber(Double(plantCarbonPrice))
        updateUICarbonBuyButton(plantCarbonPrice, buyButtonCarbon)
        
        maxWidth = 125
        // setup recebe os parametros e mudam as coisas
    }
    
    func updateUIOxygenBuyButton(_ value : Double, _ button : UIButton) {
        if value <= GameManager.shared.actualOxygen {
                button.backgroundColor = #colorLiteral(red: 0.5792971253, green: 0.8477756381, blue: 0.3774493635, alpha: 1)
        } else {
            button.backgroundColor = #colorLiteral(red: 0.3489862084, green: 0.3490410447, blue: 0.3489741683, alpha: 1)
        }
    }
    
    func updateUICarbonBuyButton(_ value : Int, _ button : UIButton) {
        if value <= GameManager.shared.carbonCredits {
                button.backgroundColor = #colorLiteral(red: 0.5792971253, green: 0.8477756381, blue: 0.3774493635, alpha: 1)
        } else {
            button.backgroundColor = #colorLiteral(red: 0.3489862084, green: 0.3490410447, blue: 0.3489741683, alpha: 1)
        }
    }
    
    func canPurchaseOxygen() -> Bool{
        
        let plantPrice = GameManager.shared.shop.plantsOxygenValue[plantInCell!.name]!
        if plantPrice <= GameManager.shared.actualOxygen {
            if (GameManager.shared.gameScene?.plantInScene.count)! < GameManager.shared.plantLimit {
                return true
            } else {
                GameManager.shared.controller!.showToast(message: "Farm plant limit reached!", font: .systemFont(ofSize: 12))
            }
                
        } else {
            GameManager.shared.controller!.showToast(message: "Insufficient oxygen", font: .systemFont(ofSize: 12))
        }
        return false
    }
    
    func canPurchaseCarbon() -> Bool {
        
        let plantPrice = GameManager.shared.shop.plantsCarbonValue[plantInCell!.name]!
        if plantPrice <= GameManager.shared.carbonCredits {
            if (GameManager.shared.gameScene?.plantInScene.count)! < GameManager.shared.plantLimit {
                return true
            } else {
                GameManager.shared.controller!.showToast(message: "Farm plant limit reached!", font: .systemFont(ofSize: 12))
            }
                
        } else {
            GameManager.shared.controller!.showToast(message: "Insufficient Carbon Credit", font: .systemFont(ofSize: 12))
        }
        return false
    }
    
    @IBAction func buyPlant(_ sender: Any) {
        
        let plantPrice = GameManager.shared.shop.plantsOxygenValue[plantInCell!.name]!
        if canPurchaseOxygen() {
            GameManager.shared.actualOxygen -= plantPrice
            GameManager.shared.gameScene?.spawnPlant(plant: plantInCell!)
            GameManager.shared.shop.updatePlantOxygenPrice(plantInCell!.name, plantPrice)
            GameManager.shared.gameScene?.playEffect("buy", "wav")
            
        }
            
        updateUIOxygenBuyButton(plantPrice, buyButtonOxygen)
        
    }
    @IBAction func buyPlantCarbon(_ sender: Any) {
        let plantPrice = GameManager.shared.shop.plantsCarbonValue[plantInCell!.name]!
        if canPurchaseCarbon() {
            GameManager.shared.carbonCredits -= plantPrice
            GameManager.shared.gameScene?.spawnPlant(plant: plantInCell!)
            GameManager.shared.shop.updatePlantCarbonPrice(plantInCell!.name, plantPrice)
            GameManager.shared.gameScene?.playEffect("buy", "wav")
            
        }
            
        updateUICarbonBuyButton(plantPrice, buyButtonCarbon)
    }
    
}
