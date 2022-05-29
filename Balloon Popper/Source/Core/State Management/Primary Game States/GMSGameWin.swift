//
//  GMSGameWin.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSGameWin is one of the game play states. In this state, the player will be notified that they've won the game.
///
/// Reference the following files for this state: ``GameWinScene``.
///
class GMSGameWin : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Credits screen.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSCreditsScreen``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSCreditsScreen.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "GameWin") {
            if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                sceneNode.scaleMode = .aspectFit
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
