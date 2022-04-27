//
//  SplashScreenAScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SpriteKit

class SplashScreenAScene : GMScene {
    private var _lastUpdateTime: TimeInterval = 0.0
    private var _labelOrgTitle: SKLabelNode? = nil
    
    override func sceneDidLoad() {
        self._lastUpdateTime = 0
        
        self._labelOrgTitle = self.childNode(withName: "\\labelOrgTitle") as? SKLabelNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self._lastUpdateTime == 0 {
            self._lastUpdateTime = currentTime
        }
        let dt = currentTime - self._lastUpdateTime
        
        self.gameMaster.pfsm.update(deltaTime: dt)
        
        if let label = self._labelOrgTitle {
            if !label.hasActions() {
                self.gameMaster.pfsm.enter(GameMaster.GMSSplashScreenB.self)
            }
        }
        
        self._lastUpdateTime = currentTime
    }
}
