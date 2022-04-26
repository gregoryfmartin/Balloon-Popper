//
//  SplashScreenAScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SpriteKit

class SplashScreenAScene : GMScene {
    override func update(_ currentTime: TimeInterval) {
        self.gameMaster.pfsm.update(deltaTime: currentTime)
    }
}
