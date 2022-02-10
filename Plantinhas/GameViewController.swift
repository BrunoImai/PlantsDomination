//
//  GameViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var emptyShopBannerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register(UINib(nibName: String(describing: plantCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: plantCollectionViewCell.self))
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            GameManager.shared.controller = self
            
           
        }
    }
    

    var currentGame: GameScene!
    @IBOutlet weak var shop: UIView!
    @IBOutlet weak var shadowBackground: UIView!
    
    @IBOutlet weak var oxygenNumberLabel: UILabel!
    
    @IBOutlet weak var limitFarmButton: UIButton!
    @IBOutlet weak var seedSpawnButton: UIButton!
    @IBOutlet weak var oxygenBoostButton: UIButton!
    @IBOutlet weak var betterPlantsButton: UIButton!
    
    @IBOutlet weak var limitFarmValueLabel: UILabel!
    @IBOutlet weak var seedSpawnValueLabel: UILabel!
    @IBOutlet weak var oxygenBoostValueLabel: UILabel!
    @IBOutlet weak var betterPlantsValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true

        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updateShopUI() {
        
        let farmLimitUpgradeValue = GameManager.shared.shop.farmLimitUpgradeValue
        let oxygenBoostUpgradeValue = GameManager.shared.shop.oxygenBoostUpgradeValue
        let seedSpawnUpgradeValue = GameManager.shared.shop.seedSpawnUpgradeValue
        
        limitFarmValueLabel.text = String(farmLimitUpgradeValue)
        oxygenBoostValueLabel.text = String(oxygenBoostUpgradeValue)
        seedSpawnValueLabel.text = String(seedSpawnUpgradeValue)
        
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
    
    @IBAction func closeShop(_ sender: Any) {
        shop.isUserInteractionEnabled = false
        shop.isHidden = true
        shadowBackground.isHidden = true
        print("Loja fechada")
    }
    @IBAction func openShop(_ sender: Any) {
        shop.isUserInteractionEnabled = true
        shop.isHidden = false
        shadowBackground.isHidden = false
        print("Loja Aberta")
        collectionView.reloadData()
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
    @IBAction func buyPlantsUpgrade(_ sender: Any) {
    }
    
}

extension GameViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { GameManager.shared.plantsDiscovered.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: plantCollectionViewCell.self), for: indexPath) as? plantCollectionViewCell else {
                return UICollectionViewCell()
            }
        
            cell.setup(indexPath.item)
            return cell
    }
}

extension GameViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 125, height: collectionView.frame.height)
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: 0, width: 250, height: 35))
    toastLabel.backgroundColor = UIColor.white
    toastLabel.textColor = UIColor.black
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.layer.position.y = 75
    }, completion: {(isCompleted) in
        UIView.animate(withDuration: 1.0, delay: 2.5, options: .curveEaseOut, animations: {
            toastLabel.layer.position.y = -20
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    })
} }
