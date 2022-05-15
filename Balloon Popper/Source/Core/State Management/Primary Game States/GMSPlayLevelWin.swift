//
//  GMSPlayLevelWin.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSPlayLevelWin is one of the game play states. In this state, the player will be congratulated for winning the level.
///
/// Reference the following files for this state: ``PlayLevelWinScene``.
///
class GMSPlayLevelWin : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Play Level state or the Game Win state.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSPlayLevel`` and ``GameMaster/GMSGameWin``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSPlayLevel.self ||
        stateClass == GMSGameWin.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "PlayLevelWin") {
            if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                sceneNode.scaleMode = .aspectFill
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
