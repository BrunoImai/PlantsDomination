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
    

    var currentGame: GameScene!

    @IBOutlet weak var oxygenNumberLabel: UILabel!
    
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
                currentGame.gameVC = self
            }
            
            view.ignoresSiblingOrder = true
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

    
    func loadOnboarding() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Onboarding")
        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
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
