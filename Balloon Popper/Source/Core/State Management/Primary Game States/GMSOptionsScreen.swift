//
//  GMSOptionsScreen.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSOptionsScreen is an auxillary state of the game. It shows a screen where the player can manipulate certain global properties of the game that will affect gameplay.
///
/// Reference the following files for this state: ``OptionsScreenScene``.
///
class GMSOptionsScreen : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Title Screen state.
    ///
    /// Reference the following classes for further information: ``GameMaster/GMSTitleScreen``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSTitleScreen.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "OptionsScreen") {
            if let sceneNode = scene.rootNode as! OptionsScreenScene? {
                sceneNode.scaleMode = .aspectFit
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
