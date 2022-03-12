//
//  SpeedSceneViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 11/03/22.
//

import UIKit
import SpriteKit
import GameKit
class SpeedSceneViewController: UIViewController {

    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    var currentGame: SpeedScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SpeedScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                currentGame = scene as? SpeedScene
                currentGame.gameVC = self
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func updateScore(with value:Double)
       {
           if (GameManager.shared.controller!.gcEnabled)
           {
               GKLeaderboard.submitScore(Int(value), context:0, player: GKLocalPlayer.local, leaderboardIDs: [GameManager.shared.controller!.gcDefaultLeaderBoard], completionHandler: {error in})
           }
       }
    
    @IBAction func backToMainScene(_ sender: Any) {
        let scene = GameScene(fileNamed: "GameScene")!
        let transition = SKTransition.moveIn(with: .right, duration: 1)
        currentGame.view?.presentScene(scene, transition: transition)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func startMinigame(_ sender: Any) {
        tutorialView.isHidden = true
        tutorialView.isUserInteractionEnabled = false
        currentGame.startGame()
        currentGame.gameStarted = true
    }
}
