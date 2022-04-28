//
//  CreditsScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI

class CreditsScreenScene : GMScene {
    private var _lastUpdateTime: TimeInterval = 0.0
    
    override func sceneDidLoad() {
        self._lastUpdateTime = 0.0
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self._lastUpdateTime == 0.0 {
            self._lastUpdateTime = currentTime
        }
        let dt = currentTime - self._lastUpdateTime
        
        self.gameMaster.pfsm.update(deltaTime: dt)
        
        self._lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
        
        self.gameMaster.pfsm.enter(GameMaster.GMSTitleScreen.self)
    }
}
