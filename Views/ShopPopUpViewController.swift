//
//  ShopPopUpViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 23/02/22.
//

import UIKit
import SpriteKit
import GameplayKit

class ShopPopUpViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var emptyShopBannerView: UIView!
    
    @IBOutlet weak var limitFarmButton: UIButton!
    @IBOutlet weak var seedSpawnButton: UIButton!
    @IBOutlet weak var oxygenBoostButton: UIButton!

    @IBOutlet weak var limitFarmValueLabel: UILabel!
    @IBOutlet weak var seedSpawnValueLabel: UILabel!
    @IBOutlet weak var oxygenBoostValueLabel: UILabel!

    var currentGame: GameScene!
    
    
    @IBOutlet weak var shopCollectionView: UICollectionView!{
        didSet {
            shopCollectionView.register(UINib(nibName: String(describing: plantCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: plantCollectionViewCell.self))
            
            shopCollectionView.dataSource = self
            shopCollectionView.delegate = self
           
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        GameManager.shared.gameScene?.popUpShopVC = self
        
    }
    
    func updateShopUI() {
        
        let farmLimitUpgradeValue = GameManager.shared.shop.farmLimitUpgradeValue
        let oxygenBoostUpgradeValue = GameManager.shared.shop.oxygenBoostUpgradeValue
        let seedSpawnUpgradeValue = GameManager.shared.shop.seedSpawnUpgradeValue
        
        limitFarmValueLabel.text = formatNumber(farmLimitUpgradeValue)
        oxygenBoostValueLabel.text = formatNumber(oxygenBoostUpgradeValue)
        seedSpawnValueLabel.text = formatNumber(seedSpawnUpgradeValue)
        
        canPurchase(farmLimitUpgradeValue, limitFarmButton)
        canPurchase(oxygenBoostUpgradeValue, oxygenBoostButton)
        canPurchase(seedSpawnUpgradeValue, seedSpawnButton)
        
        if GameManager.shared.plantsDiscovered.isEmpty {
            emptyShopBannerView.isHidden = false
        } else {
            emptyShopBannerView.isHidden = true
        }

    }
    
    func canPurchase(_ value : Double, _ button : UIButton) {
        if value <= GameManager.shared.actualOxygen {
            button.backgroundColor = #colorLiteral(red: 0.5792971253, green: 0.8477756381, blue: 0.3774493635, alpha: 1)
            button.isUserInteractionEnabled = true
        } else {
            button.backgroundColor = #colorLiteral(red: 0.3489862084, green: 0.3490410447, blue: 0.3489741683, alpha: 1)
            button.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func closePopUP(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buyLimitUpgrade(_ sender: Any) {
        GameManager.shared.shop.farmLimitUpgrade()
        
    }
    @IBAction func buySeedSpawnUpgrade(_ sender: Any) {
        GameManager.shared.shop.seedSpawnTimeUpgrade()

    }
    @IBAction func buyOxygenBoostUpgrade(_ sender: Any) {
        GameManager.shared.shop.oxygenBoostUpgrade()

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}


extension ShopPopUpViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { GameManager.shared.plantsDiscovered.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing:plantCollectionViewCell.self), for: indexPath) as? plantCollectionViewCell else {
            return UICollectionViewCell()
        }

        
        cell.setup(indexPath.item)
        return cell
        
    }
}

extension ShopPopUpViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 125, height: collectionView.frame.height)
    }
}
