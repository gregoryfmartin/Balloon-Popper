//
//  OptionsScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI

///
/// Options Screen Scene is the scene that shows the options selection for the game. It is shown by triggering its entry from the Title Screen Scene.
/// There are currently no options to choose. When the game enters this state, the user can tap on the Go Back label to return to the Title Screen scene.
///
class OptionsScreenScene : GMScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        if frontTouchedNode == "labelGoBack" {
            self.gameMaster.pfsm.enter(GMSTitleScreen.self)
        }
    }
}
