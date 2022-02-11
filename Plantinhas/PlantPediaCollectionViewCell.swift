//
//  PlantPediaCollectionViewCell.swift
//  Plantinhas
//
//  Created by Bruno Imai on 10/02/22.
//

import UIKit

class PlantPediaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var maxWidthLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    
    @IBOutlet weak var plantTinyDesc: UILabel!
    @IBOutlet weak var oxygenValue: UILabel!
    @IBOutlet weak var plantDesc: UILabel!
    
    var maxWidth : CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {return}
            maxWidthLayoutConstraint.constant = maxWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plantName.text = nil
        plantImage.image = nil
        plantDesc.text = nil
        plantTinyDesc.text = nil
        oxygenValue.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        plantName.text = nil
        plantImage.image = nil
        plantDesc.text = nil
        plantTinyDesc.text = nil
        oxygenValue.text = nil
    }
    func setup(_ plantIndex: Int) {
        let plant = GameManager.shared.plantsDiscovered[plantIndex]
        
        plantImage.image = UIImage.init(named: plant.name)
        plantName.text = plant.name
        plantDesc.text = plant.desc
        plantTinyDesc.text = plant.tinyDesc
        
        let plantPrice = GameManager.shared.shop.plantsValue[plant.name]!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        let number =  numberFormatter.string(from: NSNumber(value: plantPrice))
        
        oxygenValue.text = number
        maxWidth = 250
    }
}
