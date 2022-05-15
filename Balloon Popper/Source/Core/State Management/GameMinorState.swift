//
//  GameMinorState.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/11/22.
//

import GameplayKit

class GameMinorState : GKState {
    internal var _gms: GameMasterStates
    
    init (_ gms: GameMasterStates) {
        self._gms = gms
    }
}
