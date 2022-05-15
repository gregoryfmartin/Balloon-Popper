//
//  GMSSplashScreenB.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSSplashScreenB is the second state of the game. It shows the Snowy Bear screen, because I want to pad the splash screens with as much useless content as I possibly can.
///
/// Reference the following files for this state: ``SplashScreenBScene``
///
class GMSSplashScreenB : GameMasterStates {
    ///
    /// Acts as a time accumulator for the state. This really should be promoted to the base class since all of the states may need something like this in the future.
    ///
    private var _cumulativeUpdateTime: TimeInterval = 0.0
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var cumulativeUpdateTime: TimeInterval {
        get {
            return self._cumulativeUpdateTime
        }
    }
    
    ///
    /// Defines the valid next states. From this state, we can only enter the Title Screen state.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSTitleScreen``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSTitleScreen.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "SplashScreenB") {
            if let sceneNode = scene.rootNode as! SplashScreenBScene? {
                sceneNode.scaleMode = .aspectFill
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
    
    ///
    /// Update the ``GameMaster/GMSSplashScreenB/cumulativeUpdateTime`` value by incrementing it by the seconds. If this accumulator is greater than 7.0, trigger the owning FSM to transition to the next state.
    ///
    override func update (deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self._cumulativeUpdateTime += seconds
        
        if self._cumulativeUpdateTime >= 7.0 {
            self.stateMachine?.enter(GMSTitleScreen.self)
        }
    }
}
