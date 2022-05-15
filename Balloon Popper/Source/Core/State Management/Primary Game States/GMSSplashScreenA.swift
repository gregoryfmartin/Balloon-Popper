//
//  GMSSplashScreenA.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSSplashScreenA is the initial state of the game. It shows a splash screen that shows the gregfmartin.org label in a fashion similar to a legacy Game Boy.
///
/// Reference the following files for this state: ``SplashScreenAScene``
///
class GMSSplashScreenA : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Splash Screen B state.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSSplashScreenB``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSSplashScreenB.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "SplashScreenA") {
            if let sceneNode = scene.rootNode as! SplashScreenAScene? {
                sceneNode.scaleMode = .aspectFill
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
