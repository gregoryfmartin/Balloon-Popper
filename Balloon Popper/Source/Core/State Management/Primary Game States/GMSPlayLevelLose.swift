//
//  GMSPlayLevelLose.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSPlayLevelLose is one of the game play states. In this state, the player will be notified that they've lost the level and will be prompted in different ways based on the number of lives left and the number of continues left.
///
/// Reference the following files for this state: ``PlayLevelLoseScene``.
///
class GMSPlayLevelLose : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Play Level state or the Game Lose state.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSPlayLevel`` and ``GameMaster/GMSGameLose``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSPlayLevel.self ||
        stateClass == GMSGameLose.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "PlayLevelLose") {
            if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                sceneNode.scaleMode = .aspectFit
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
