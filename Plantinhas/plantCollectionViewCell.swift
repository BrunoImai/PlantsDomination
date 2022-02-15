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
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plantImage.image = nil
        plantNameOutlet.text = nil
        oxygenPrice.text = nil
        
        // colocar cores fonte etc
        // Setar coisas que mudam para nulo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plantImage.image = nil
        plantNameOutlet.text = nil
        oxygenPrice.text = nil
        
        // Colocar tudo nulo dnv as coisas do awake from inib
    }

    func setup(_ plantIndex: Int) {
        let plant = GameManager.shared.plantsDiscovered[plantIndex]
        plantInCell = plant
        plantImage.image = UIImage.init(named: plant.name)
        plantNameOutlet.text = plant.name
        
        let plantPrice = GameManager.shared.shop.plantsValue[plant.name]!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        let number =  numberFormatter.string(from: NSNumber(value: plantPrice))
        oxygenPrice.text = number
        updateUIBuyButton(plantPrice, buyButton)
        
        maxWidth = 125
        // setup recebe os parametros e mudam as coisas
    }
    
    func updateUIBuyButton(_ value : Double, _ button : UIButton) {
        if value <= GameManager.shared.actualOxygen {
                button.backgroundColor = #colorLiteral(red: 0.5792971253, green: 0.8477756381, blue: 0.3774493635, alpha: 1)
        } else {
            button.backgroundColor = #colorLiteral(red: 0.3489862084, green: 0.3490410447, blue: 0.3489741683, alpha: 1)
        }
    }
    
    func canPurchase() -> Bool{
        
        let plantPrice = GameManager.shared.shop.plantsValue[plantInCell!.name]!
        if plantPrice <= GameManager.shared.actualOxygen {
            if (GameManager.shared.gameScene?.plantInScene.count)! < GameManager.shared.plantLimit {
                return true
            } else {
                GameManager.shared.controller!.showToast(message: "Limite de plantas na fazenda atingido!", font: .systemFont(ofSize: 12))
            }
                
        } else {
            print()
            GameManager.shared.controller!.showToast(message: "Oxigênio insuficiente", font: .systemFont(ofSize: 12))
                
            
        }
        return false
    }
    @IBAction func buyPlant(_ sender: Any) {
        
        let plantPrice = GameManager.shared.shop.plantsValue[plantInCell!.name]!
        if canPurchase() {
            GameManager.shared.actualOxygen -= plantPrice
            GameManager.shared.gameScene?.spawnPlant(plant: plantInCell!)
            GameManager.shared.shop.updatePlantPrice(plantInCell!.name, plantPrice)
            GameManager.shared.gameScene?.playEffect("buy", "wav")
            
        }
            
        updateUIBuyButton(plantPrice, buyButton)
        
    }
    
}
