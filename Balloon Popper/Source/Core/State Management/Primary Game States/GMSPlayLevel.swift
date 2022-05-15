//
//  GMSPlayLevel.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSPlayLevel is one of the game play states. In this state, the player will actually play the game. This is the only state where a secondary FSM exists which will govern the exact progress of scenes themselves.
///
/// Reference the following files for this state: ``PlayLevelScene``.
///
class GMSPlayLevel : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the Play Level Win state, the Play Level Lose state, or the Title Screen state.
    ///
    /// Reference the following classes for more information: ``GameMaster/GMSPlayLevelWin``, ``GameMaster/GMSPlayLevelLose``, ``GameMaster/GMSTitleScreen``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSPlayLevelWin.self ||
        stateClass == GMSPlayLevelLose.self ||
        stateClass == GMSTitleScreen.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "PlayLevel") {
            if let sceneNode = scene.rootNode as! PlayLevelScene? {
                sceneNode.scaleMode = .aspectFill
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
