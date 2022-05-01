//
//  CreditsScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI

class CreditsScreenScene : GMScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameMaster.pfsm.enter(GameMaster.GMSTitleScreen.self)
    }
}
