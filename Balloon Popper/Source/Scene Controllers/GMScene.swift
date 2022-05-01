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
    private var _lastUpdateTime: TimeInterval = 0.0
    
    public var gameMaster: GameMaster {
        get {
            return self._gameMaster!
        }
        set {
            self._gameMaster = newValue
        }
    }
    
    public var lastUpdateTime: TimeInterval {
        get {
            return self._lastUpdateTime
        }
        set {
            self._lastUpdateTime = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self._lastUpdateTime == 0.0 {
            self._lastUpdateTime = currentTime
        }
        let dt = currentTime - self._lastUpdateTime
        
        self._gameMaster?.pfsm.update(deltaTime: dt)
        
        self._lastUpdateTime = currentTime
    }
}
