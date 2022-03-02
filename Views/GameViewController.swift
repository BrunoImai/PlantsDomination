//
//  GameViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {

    @IBOutlet weak var adButton: UIButton!
    
    var currentGame: GameScene!
    var rewardedAD : GADRewardedAd?

    var timer = Timer()
    
    @IBOutlet weak var oxygenNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadRewardAd()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? GameScene
                currentGame.gameVC = self
            }
            
            view.ignoresSiblingOrder = true
        }
        timer = Timer.scheduledTimer(timeInterval: 350.0, target: self, selector: #selector(showAdButton), userInfo: nil, repeats: true)
        
        GameManager.shared.controller = self
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

    
    func loadOnboarding() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Onboarding")
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
//MARK: Ads Logic
    
    var adInScreen = true
    
    func loadRewardAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-2003885569288303/9199244739", request: request) { ad, error in
            guard let error = error else {
                self.rewardedAD = ad
                self.rewardedAD?.fullScreenContentDelegate = self
                return
                
            }
            print("Rewarded ad failed to load with error: ", error)
        }
    }
    

    
    @objc func showAdButton() {
        if !adInScreen {
            adButton.isHidden = false
            adButton.isUserInteractionEnabled = true
            adInScreen = true
        }
        
    }

    @IBAction func teste(_ sender: Any) {
        presentRewardedAd()
        
    }
}

extension GameViewController : GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Erro ao apresentar em fullscreen: ", error)
        showToast(message: "Erro ao apresentar AD", font: .systemFont(ofSize: 12))
        loadRewardAd()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad foi apresentado em fullscreen")
        //MARK: tirar todos os sons
        adButton.isHidden = true
        adButton.isUserInteractionEnabled = false
        adInScreen = false
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad foi dispensado da fullscreen")
        //MARK: voltar todos os sons
        loadRewardAd()
    }
    
    func presentRewardedAd() {
        if let ad = rewardedAD {
            ad.present(fromRootViewController: self) {
                //MARK: FAZER A LOGICA AQ
                GameManager.shared.carbonCredits += 100
            }
        }
    }
    
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: 0, width: 250, height: 35))
    toastLabel.layer.zPosition = 20000
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
