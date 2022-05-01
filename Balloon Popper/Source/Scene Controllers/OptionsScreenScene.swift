//
//  OptionsScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI

class OptionsScreenScene : GMScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        if frontTouchedNode == "labelGoBack" {
            self.gameMaster.pfsm.enter(GameMaster.GMSTitleScreen.self)
        }
    }
}
