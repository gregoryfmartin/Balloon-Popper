//
//  SplashScreenAScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SpriteKit

class SplashScreenAScene : GMScene {
    private var _labelOrgTitle: SKLabelNode? = nil
    
    override func sceneDidLoad() {
        self._labelOrgTitle = self.childNode(withName: "\\labelOrgTitle") as? SKLabelNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if let label = self._labelOrgTitle {
            if !label.hasActions() {
                self.run(SKAction.wait(forDuration: 6.0))
                self.gameMaster.pfsm.enter(GameMaster.GMSSplashScreenB.self)
            }
        }
    }
}
