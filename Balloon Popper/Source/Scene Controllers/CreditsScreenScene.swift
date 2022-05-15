//
//  CreditsScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI

///
/// Credits Screen Scene is the scene that shows the credits for the game. It's accessed by tapping the Credits label on the Title Screen Scene.
/// The credits runs an auto-scroller element that makes the text roll from the bottom toward the top. The player can exit the credits roll at any time by simply tapping the screen.
///
class CreditsScreenScene : GMScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameMaster.pfsm.enter(GMSTitleScreen.self)
    }
}
