//
//  GameMaster.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/24/22.
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
    fileprivate var _gm: GameMaster
    
    ///
    /// A reference to the SKView that will show the content. This is required for scene transitions.
    ///
    fileprivate var _skv: SKView
    
    init (_ gm: GameMaster, _ skv: SKView) {
        self._gm = gm
        self._skv = skv
    }
}

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
    /// GMSSplashScreenA is the initial state of the game. It shows a splash screen that shows the gregfmartin.org label in a fashion similar to a legacy Game Boy.
    ///
    /// Reference the following files for this state: ``SplashScreenAScene``
    ///
    class GMSSplashScreenA : GameMasterStates {
        ///
        /// Defines the valid next states. From this state, we can only enter the Splash Screen B state.
        ///
        /// Reference the following classes for more information: ``GameMaster/GMSSplashScreenB``.
        ///
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSSplashScreenB.self
        }
        
        ///
        /// Handle a transition animation to move into this state.
        ///
        override func didEnter (from previousState: GKState?) {
            if let scene = GKScene(fileNamed: "SplashScreenA") {
                if let sceneNode = scene.rootNode as! SplashScreenAScene? {
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
    ///
    /// GMSSplashScreenB is the second state of the game. It shows the Snowy Bear screen, because I want to pad the splash screens with as much useless content as I possibly can.
    ///
    /// Reference the following files for this state: ``SplashScreenBScene``
    ///
    class GMSSplashScreenB : GameMasterStates {
        ///
        /// Acts as a time accumulator for the state. This really should be promoted to the base class since all of the states may need something like this in the future.
        ///
        private var _cumulativeUpdateTime: TimeInterval = 0.0
        
        ///
        /// Public accessor for the private member of the same name.
        ///
        public var cumulativeUpdateTime: TimeInterval {
            get {
                return self._cumulativeUpdateTime
            }
        }
        
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
            if let scene = GKScene(fileNamed: "SplashScreenB") {
                if let sceneNode = scene.rootNode as! SplashScreenBScene? {
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
        
        ///
        /// Update the ``GameMaster/GMSSplashScreenB/cumulativeUpdateTime`` value by incrementing it by the seconds. If this accumulator is greater than 7.0, trigger the owning FSM to transition to the next state.
        ///
        override func update (deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            self._cumulativeUpdateTime += seconds
            
            if self._cumulativeUpdateTime >= 7.0 {
                self.stateMachine?.enter(GMSTitleScreen.self)
            }
        }
    }
    
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
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
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
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
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
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
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
                if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
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
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
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
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
        }
    }
    
    ///
    /// GMSGameLose is one of the game play states. In this state, the player will be notified that they've lost the game.
    ///
    /// Reference the following files for this state: ``GameLoseScene``.
    ///
    class GMSGameLose : GameMasterStates {
        ///
        /// Defines the valid next states. From this state, we can only enter the Title screen.
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
            if let scene = GKScene(fileNamed: "GameLose") {
                if let sceneNode = scene.rootNode as! CreditsScreenScene? {
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.gameMaster = self._gm
                    let reveal = SKTransition.fade(withDuration: 0.5)
                    self._skv.presentScene(sceneNode, transition: reveal)
                }
            }
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
