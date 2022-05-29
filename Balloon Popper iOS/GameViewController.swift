//
//  GameViewController.swift
//  Balloon Popper iOS
//
//  Created by Gregory Frank Martin on 4/26/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private var gameMaster: GameMaster? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            self.gameMaster = GameMaster(view)
            if let v = view.scene as? GMScene {
                v.gameMaster = self.gameMaster!
                v.scaleMode = .aspectFit
            }
        }
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
//        if let scene = GKScene(fileNamed: "GameScene") {
//
//            // Get the SKScene from the loaded GKScene
//            if let sceneNode = scene.rootNode as! GameScene? {
//
//                // Copy gameplay related content over to the scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
//
//                // Set the scale mode to scale to fit the window
//                sceneNode.scaleMode = .aspectFill
//
//                // Present the scene
//                if let view = self.view as! SKView? {
//                    view.presentScene(sceneNode)
//
//                    view.ignoresSiblingOrder = true
//
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                }
//            }
//        }
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
}
