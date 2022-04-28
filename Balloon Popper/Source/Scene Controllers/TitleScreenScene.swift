//
//  TitleScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI // This needs included for the touch event recognition, otherwise UITouch and UIEvent can't be found

class TitleScreenScene : GMScene {
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
    
    ///
    /// Override this function to enable touch detection.
    ///
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        if frontTouchedNode == "labelOptions" {
            self.gameMaster.pfsm.enter(GameMaster.GMSOptionsScreen.self)
        }
        if frontTouchedNode == "labelCredits" {
            self.gameMaster.pfsm.enter(GameMaster.GMSCreditsScreen.self)
        }
        
        print("Touched node: \(String(describing: frontTouchedNode))")
    }
}
