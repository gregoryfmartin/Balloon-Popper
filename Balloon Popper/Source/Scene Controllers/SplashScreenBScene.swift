//
//  SplashScreenBScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SpriteKit

class SplashScreenBScene : GMScene {
    private var _lastUpdateTime: TimeInterval = 0.0
    private var _splashScreenBear: SplashScreenBear? = nil
    
    override func sceneDidLoad() {
        self._lastUpdateTime = 0.0
        self._splashScreenBear = self.childNode(withName: "\\splashScreenBear") as? SplashScreenBear
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self._lastUpdateTime == 0.0 {
            self._lastUpdateTime = currentTime
        }
        let dt = currentTime - self._lastUpdateTime
        
        self.gameMaster.pfsm.update(deltaTime: dt)
        self._splashScreenBear?.update(dt)
        
        self._lastUpdateTime = currentTime
    }
}
