//
//  ViewController.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/21/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    var gameMaster: GameMaster? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        
        self.gameMaster = GameMaster(self.skView)
        if let v = self.skView.scene as? GMScene {
            v.gameMaster = self.gameMaster!
        }
    }
}

