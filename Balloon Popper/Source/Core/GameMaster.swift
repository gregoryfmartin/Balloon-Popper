//
//  GameMaster.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/24/22.
//

import GameplayKit
import SpriteKit

///
/// The GameMaster controls the overall state of the game. Different states will cause different scenes to appear in the root SKView that the application ViewController owns. Each state is documented in its own course within the class.
///
class GameMaster {
    ///
    /// A MastMaster instance that will handle all of the math crap for the game.
    ///
    private var _mathMaster: MathMaster = MathMaster()
    
    ///
    /// The primary state machine, responsible for managing the global state of the game.
    ///
    private var _pfsm: GKStateMachine = GKStateMachine(states: [])
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var pfsm: GKStateMachine {
        get {
            return self._pfsm
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var mathMaster: MathMaster {
        get {
            return self._mathMaster
        }
    }
    
    ///
    /// Populates the primary FSM with its states.
    ///
    private func buildFsms (_ skv: SKView) {
        self._pfsm = GKStateMachine(states: [
            GMSSplashScreenA(self, skv),
            GMSSplashScreenB(self, skv),
            GMSTitleScreen(self, skv),
            GMSOptionsScreen(self, skv),
            GMSCreditsScreen(self, skv),
            GMSPlayLevel(self, skv),
            GMSPlayLevelWin(self, skv),
            GMSPlayLevelLose(self, skv),
            GMSGameWin(self, skv),
            GMSGameLose(self, skv)
        ])
    }
    
    init (_ skv: SKView) {
        self.buildFsms(skv)
        self._pfsm.enter(GMSSplashScreenA.self)
    }
}
