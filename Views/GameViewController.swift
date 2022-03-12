//
//  GameViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 26/01/22.
//

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate {


    @IBOutlet weak var offset: UIView!
    @IBOutlet weak var adViewContainer: UIView!
    @IBOutlet weak var adButton: UIButton!
    
    var currentGame: GameScene!
    var rewardedAD : GADRewardedAd?

    var timer = Timer()
    
    @IBOutlet weak var oxygenNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
       
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
    
    @IBAction func showAd(_ sender: Any) {
        presentRewardedAd()
        adViewContainer.isHidden = true
        adViewContainer.isUserInteractionEnabled = false
        offset.isHidden = true
    }
    
    @IBAction func showAdPopUp(_ sender: Any) {
        adViewContainer.isHidden = false
        adViewContainer.isUserInteractionEnabled = true
        adButton.isHidden = true
        offset.isHidden = false
    }
    
    @IBAction func closeAdPopUp(_ sender: Any) {
        adViewContainer.isHidden = true
        adViewContainer.isUserInteractionEnabled = false
        adButton.isHidden = false
        offset.isHidden = true
    }
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

    @IBAction func showSpeedMinigame(_ sender: Any) {
//        let scene = SpeedScene(fileNamed: "SpeedScene")!
//        let transition = SKTransition.moveIn(with: .right, duration: 1)
//        currentGame.view?.presentScene(scene, transition: transition)
    }
    
    //MARK: GAMECENTER
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true
                
                localPlayer.setDefaultLeaderboardIdentifier("speedMiniGameLeaderBoard", completionHandler: { ( error) in
                    if error != nil {
                        print(error!)
                        print("DEU RUIMMMMMMMMMMMMMMMMMMM")
                    }
                    else {
                        print("DEU BOMMMMMMMMMMMMMM")
            
                    }
                })
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                        print(leaderboardIdentifer, "DEU RUIMMMMMMMMMMMMMMMMMMM")
                    }
                    else {
                        print(leaderboardIdentifer, "DEU BOMMMMMMMMMMMMMM")
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
                
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    @IBAction func showLeaderBoard(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
            GameCenterVC.gameCenterDelegate = self
            present(GameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    
}

extension GameViewController : GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Erro ao apresentar em fullscreen: ", error)
        showToast(message: "Error in AD presentation", font: .systemFont(ofSize: 12))
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
                GameManager.shared.carbonCredits += 10
                self.showToast(message: "10 Carbon credit added!", font: .systemFont(ofSize: 12))
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
