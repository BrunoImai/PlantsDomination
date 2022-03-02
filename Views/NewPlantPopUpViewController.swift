//
//  NewPlantPopUpViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 23/02/22.
//

import UIKit

class NewPlantPopUpViewController: UIViewController {

    
    @IBOutlet weak var newPlantImage: UIImageView!
    @IBOutlet weak var newPlantName: UILabel!
    @IBOutlet weak var newPlantTinyDesc: UILabel!
    @IBOutlet weak var oxygenProduction: UILabel!
    @IBOutlet weak var newPlantDesc: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Carregado com sucesso")
        _ = self.view
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        _ = self.view
    }
    
    func setPlantAchived(_ plant : Plant) {
            newPlantDesc.text = plant.desc
            newPlantName.text = plant.name
            newPlantTinyDesc.text = plant.tinyDesc
    
            oxygenProduction.text = formatNumber(plant.oxygenProduction)
            newPlantImage.image = UIImage.init(named: plant.name)
    
        }
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
