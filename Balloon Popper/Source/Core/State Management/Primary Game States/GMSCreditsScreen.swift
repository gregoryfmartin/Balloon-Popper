//
//  GMSCreditsScreen.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSCreditsScreen is an auxillary state of the game. It shows a screen where the player can view the credits.
///
/// Reference the following files for this state: ``CreditsScreenScene``.
///
class GMSCreditsScreen : GameMasterStates {
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
        if let scene = GKScene(fileNamed: "CreditsScreen") {
            if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                sceneNode.scaleMode = .aspectFit
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
