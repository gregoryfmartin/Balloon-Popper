//
//  GameMasterState.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit
import SpriteKit

///
/// The base class that serves as the foundation for all states that the GameMaster object's FSM can be in.
///
class GameMasterStates : GKState {
    ///
    /// A reference to the GameMaster instance that owns the FSM.
    ///
    internal var _gm: GameMaster
    
    ///
    /// A reference to the SKView that will show the content. This is required for scene transitions.
    ///
    internal var _skv: SKView
    
    init (_ gm: GameMaster, _ skv: SKView) {
        self._gm = gm
        self._skv = skv
    }
}
