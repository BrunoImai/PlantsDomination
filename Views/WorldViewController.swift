//
//  WorldViewController.swift
//  Plantinhas
//
//  Created by Bruno Imai on 08/03/22.
//

import UIKit
import SceneKit

class WorldViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    let cameraNode = SCNNode()
    let lightNode = SCNNode()
    let earthNode = WorldNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()

        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(0, 0, 5)
         
        scene.rootNode.addChildNode(earthNode)
        
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.position = SCNVector3(0, 0, 0)
        lightNode.light?.intensity = 600
        
        let lightConstraint = SCNBillboardConstraint()
        lightNode.constraints = [SCNBillboardConstraint()]
        lightNode.constraints?.append(lightConstraint)
        
        cameraNode.addChildNode(lightNode)
        
        
        scene.rootNode.addChildNode(cameraNode)

        sceneView.pointOfView?.addChildNode(lightNode)
        
        sceneView.scene = scene
        
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        sceneView.delegate = self
        
        addShape(pos: SCNVector3(0.5, 0, 0.9), to: earthNode)
        
    }
    
    func registerGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(search))
        self.sceneView.addGestureRecognizer(tap)
    }

    @objc func search(sender: UITapGestureRecognizer) {

        let sceneView = sender.view as! SCNView
        let location = sender.location(in: sceneView)
        let results = sceneView.hitTest(location, options: [SCNHitTestOption.searchMode : 1])

        guard sender.state == .ended else { return }

        for result in results {
            print(result.node.name!)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addShape(pos: SCNVector3, to: SCNNode) {

        let radius = Float(0.05)

        let objectSph = SCNSphere(radius: CGFloat(radius))
        let object = SCNNode(geometry: objectSph)
        let position = SCNVector3Make(pos.x, pos.y, pos.z)
        
        object.name = "um nome ai"
        object.position = position
        object.geometry?.firstMaterial?.diffuse.contents = UIColor.red

        to.addChildNode(object)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == self.sceneView){
            print("touch working")
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            if result.node.name != nil{
                print(result.node.name)
//                let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
//                       self.navigationController?.pushViewController(firstVC, animated: true)
                self.dismiss(animated: true)
            }
        }
    }
}
extension WorldViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        let action = SCNAction.move(to: SCNVector3(300, 300, 0), duration: 5)

        lightNode.runAction(action)
        

  }
}
