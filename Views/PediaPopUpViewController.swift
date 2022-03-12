//
//  PediaPopUpViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 23/02/22.
//

import UIKit

class PediaPopUpViewController: UIViewController {

    
    @IBOutlet weak var pediaCollectionView: UICollectionView!{
        didSet {
            pediaCollectionView.register(UINib(nibName: String(describing: PlantPediaCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PlantPediaCollectionViewCell.self))
            
            pediaCollectionView.dataSource = self
            pediaCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.shared.gameScene?.popUpPediaVC = self
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}



extension PediaPopUpViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { GameManager.shared.plantsDiscovered.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlantPediaCollectionViewCell.self), for: indexPath) as? PlantPediaCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            cell.setup(indexPath.item)
            return cell
        
    }
}

extension PediaPopUpViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 450)
    }
}
