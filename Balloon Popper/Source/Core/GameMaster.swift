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



class GameMaster {
    private var _mathMaster: MathMaster = MathMaster()
    
    ///
    /// The primary state machine, responsible for managing the global state of the game.
    ///
    private var _pfsm: GKStateMachine = GKStateMachine(states: [])
    
    public var pfsm: GKStateMachine {
        get {
            return self._pfsm
        }
    }
    
    public var mathMaster: MathMaster {
        get {
            return self._mathMaster
        }
    }
    
    class GMSSplashScreenA : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSSplashScreenB.self
        }
        
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
        
        override func update (deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
        }
    }
    
    class GMSSplashScreenB : GameMasterStates {
        private var _cumulativeUpdateTime: TimeInterval = 0.0
        
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSTitleScreen.self
        }
        
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
        
        override func update (deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            self._cumulativeUpdateTime += seconds
            
            if self._cumulativeUpdateTime >= 7.0 {
                self.stateMachine?.enter(GMSTitleScreen.self)
            }
        }
    }
    
    class GMSTitleScreen : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSOptionsScreen.self ||
            stateClass == GMSCreditsScreen.self ||
            stateClass == GMSPlayLevel.self
        }
        
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
    
    class GMSOptionsScreen : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSTitleScreen.self
        }
        
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
    
    class GMSCreditsScreen : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSTitleScreen.self
        }
        
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
    
    class GMSPlayLevel : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSPlayLevelWin.self ||
            stateClass == GMSPlayLevelLose.self ||
            stateClass == GMSTitleScreen.self
        }
        
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
        
        override func update(deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
        }
    }
    
    class GMSPlayLevelWin : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSPlayLevel.self ||
            stateClass == GMSGameWin.self
        }
        
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
    
    class GMSPlayLevelLose : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSPlayLevel.self ||
            stateClass == GMSGameLose.self
        }
        
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
    
    class GMSGameWin : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSCreditsScreen.self
        }
        
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
    
    class GMSGameLose : GameMasterStates {
        override func isValidNextState (_ stateClass: AnyClass) -> Bool {
            return stateClass == GMSTitleScreen.self
        }
        
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
    
//    init (_ vc: ViewController) {
//        self.buildFsms(vc)
//        self._pfsm.enter(GMSSplashScreenA.self)
//    }
    
    init (_ skv: SKView) {
        self.buildFsms(skv)
        self._pfsm.enter(GMSSplashScreenA.self)
    }
}
