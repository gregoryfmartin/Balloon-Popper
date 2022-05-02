//
//  GMScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import SpriteKit

///
/// GMScene is an abstraction of SKScene, providing certain extensions that I need for this game engine.
///
class GMScene : SKScene {
    ///
    /// An instance of GameMaster. Each scene will need a reference to the instance created in the ViewController.
    ///
    private var _gameMaster: GameMaster? = nil
    
    ///
    /// Used for measuring delta time for FPS.
    ///
    private var _lastUpdateTime: TimeInterval = 0.0
    
    ///
    /// Public interface for the private member of the same name.
    ///
    public var gameMaster: GameMaster {
        get {
            return self._gameMaster!
        }
        set {
            self._gameMaster = newValue
        }
    }
    
    ///
    /// Public interface for the private member of the same name.
    ///
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
    
    ///
    /// Does nothing out of the ordinary except for calculating delta time and ensuring that the Primary FSM in the GameMaster is able to run its update function using the delta time.
    ///
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
