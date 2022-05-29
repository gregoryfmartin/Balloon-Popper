//
//  GMSTitleScreen.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// GMSTitleScreen is the third state of the game. It shows the title screen - a hub - from where the player can select one of a few selections to navigate to different areas of the game.
///
/// Reference the following files for this state: ``TitleScreenScene``
///
class GMSTitleScreen : GameMasterStates {
    ///
    /// Defines the valid next states. From this state, we can only enter the options screen, credits screen, or the play screen.
    ///
    /// Reference the following classes for further information: ``GameMaster/GMSOptionsScreen``, ``GameMaster/GMSCreditsScreen``, ``GameMaster/GMSPlayLevel``.
    ///
    override func isValidNextState (_ stateClass: AnyClass) -> Bool {
        return stateClass == GMSOptionsScreen.self ||
        stateClass == GMSCreditsScreen.self ||
        stateClass == GMSPlayLevel.self
    }
    
    ///
    /// Handle a transition animation to move into this state.
    ///
    override func didEnter (from previousState: GKState?) {
        if let scene = GKScene(fileNamed: "TitleScreen") {
            if let sceneNode = scene.rootNode as! TitleScreenScene? {
                sceneNode.scaleMode = .aspectFit
                sceneNode.gameMaster = self._gm
                let reveal = SKTransition.fade(withDuration: 0.5)
                self._skv.presentScene(sceneNode, transition: reveal)
            }
        }
    }
}
