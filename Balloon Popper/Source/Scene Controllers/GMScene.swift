//
//  GMScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SpriteKit

class GMScene : SKScene {
    private var _gameMaster: GameMaster? = nil
    
    public var gameMaster: GameMaster {
        get {
            return self._gameMaster!
        }
        set {
            self._gameMaster = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
