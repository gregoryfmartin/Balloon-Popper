//
//  PlayLevelScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import SpriteKit
import GameplayKit

///
/// The Play Level Scene is synonymous with the "Arena" screen. This is the scene that contains the play area that the player will use to play the game with.
///
/// There are several sub-states for this scene, which dictate how the screen plays. The states will be documented in the GameMaster's documentation.
///
class PlayLevelScene : GMScene {
    class SceneMinorState: GKState {
        fileprivate var _scene: GMScene
        
        init(_ scene: GMScene) {
            self._scene = scene
        }
    }
    
    class PLSStarting: SceneMinorState {
        static private let READY_APPEAR_ACTION_DURATION: CGFloat = 0.35
        static private let GO_APPEAR_ACTION_DURATION: CGFloat = 0.35
        static private let READY_FADE_ACTION_DURATION: CGFloat = 0.35
        static private let GO_FADE_ACTION_DURATION: CGFloat = 0.35
        static private let READY_START_POINT: CGPoint = CGPoint(x: -1000.0, y: 0.0)
        static private let GO_START_POINT: CGPoint = CGPoint(x: 1000.0, y: 0.0)
        static private let LABEL_FONT_SIZE: CGFloat = 100.0
        static private let LABEL_FONT_COLOR: UIColor = .white
        
        private var _readyLabel: SKLabelNode = SKLabelNode(text: "Ready?")
        private var _goLabel: SKLabelNode = SKLabelNode(text: "Go!")
        private var _readyLabelAppearAction: SKAction = SKAction.moveTo(x: 0.0, duration: READY_APPEAR_ACTION_DURATION)
        private var _goLabelAppearAction: SKAction = SKAction.moveTo(x: 0.0, duration: GO_APPEAR_ACTION_DURATION)
        private var _readyLabelHideAction: SKAction = SKAction.fadeOut(withDuration: READY_FADE_ACTION_DURATION)
        private var _goLabelHideAction: SKAction = SKAction.fadeOut(withDuration: GO_FADE_ACTION_DURATION)
        private var _readyVfx: SKAction = SKAction.playSoundFileNamed("Voice Ready", waitForCompletion: true)
        private var _goVfx: SKAction = SKAction.playSoundFileNamed("Voice Go", waitForCompletion: true)
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == PLSStarted.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Provision the nodes
            self._readyLabel.position = PLSStarting.READY_START_POINT
            self._readyLabel.fontSize = PLSStarting.LABEL_FONT_SIZE
            self._readyLabel.fontColor = PLSStarting.LABEL_FONT_COLOR
            self._goLabel.position = PLSStarting.GO_START_POINT
            self._goLabel.fontSize = PLSStarting.LABEL_FONT_SIZE
            self._goLabel.fontColor = PLSStarting.LABEL_FONT_COLOR
            
            // Add the nodes to the parent
            self._scene.addChild(self._readyLabel)
            self._scene.addChild(self._goLabel)
            
            // Run the actions
            self._readyLabel.run(SKAction.sequence([
                self._readyLabelAppearAction,
                self._readyVfx,
                self._readyLabelHideAction,
                SKAction.run {
                    self._goLabel.run(SKAction.sequence([
                        self._goLabelAppearAction,
                        self._goVfx,
                        self._goLabelHideAction,
                        SKAction.run {
                            self.stateMachine?.enter(PLSStarted.self)
                        }
                    ]))
                }
            ]))
        }
        
        
        override func willExit(to nextState: GKState) {
            // Remove the nodes from the scene
            self._scene.removeChildren(in: [
                self._readyLabel,
                self._goLabel
            ])
        }
    }
    
    class PLSStarted: SceneMinorState {
        // Constants
        private static let TOP_UI_CONTAINER_HEIGHT_SCALAR: CGFloat = 0.075
        private static let BOTTOM_UI_CONTAINER_HEIGHT_SCALAR: CGFloat = 0.075
        
        // Nodes for the UI
        private var _topUiContainer: SKTopUiContainer? = nil
        private var _bottomUiContainer: SKBottomUiContainer? = nil
        private var _levelLabel: SKLabelNode = SKLabelNode(text: "Level")
        private var _levelValue: SKLabelNode = SKLabelNode()
        private var _balloonsToTapLabel: SKLabelNode = SKLabelNode(text: "To Pop")
        private var _balloonsToTapValue: SKLabelNode = SKLabelNode()
        private var _balloonsTappedLabel: SKLabelNode = SKLabelNode(text: "Popped")
        private var _balloonsTappedValue: SKLabelNode = SKLabelNode()
        private var _scoreLabel: SKLabelNode = SKLabelNode(text: "Score")
        private var _scoreValue: SKLabelNode = SKLabelNode()
        private var _bgm: SKAudioNode = SKAudioNode(fileNamed: "Play Arena Music A")
        
        private var _sampleBalloon: ModernBalloon? = nil
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == PLSEnding.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Grab some commonly used metadata
            let sceneFrameWidth = self._scene.frame.width
            let sceneFrameHeight = self._scene.frame.height
            
            // Prepare the level for use
            let mathMasterRef = self._scene.gameMaster.mathMaster
            mathMasterRef.prepareLevel()
            
            self._sampleBalloon = ModernBalloon(mathMaster: mathMasterRef, sceneFrame: self._scene.frame)
//            self._sampleBalloon?.position = CGPoint(x: 0.0, y: -(sceneFrameHeight / 2.0) - 100.0)
//            self._sampleBalloon?.zPosition = 0.5
            
            // Add the MathMaster data to the correct nodes
            self._levelValue.text = String(mathMasterRef.currentLevel)
            
            // Provision the nodes
            // Most of this is going to be dynamic positioning.
//            print("\(self._scene.frame.width) x  \(self._scene.frame.height)")
            
            self._topUiContainer = SKTopUiContainer(sceneFrameWidth: sceneFrameWidth, sceneFrameHeight: sceneFrameHeight)
            self._bottomUiContainer = SKBottomUiContainer(sceneFrameWidth: sceneFrameWidth, sceneFrameHight: sceneFrameHeight)
            self._topUiContainer?.zPosition = 1.0
            self._bottomUiContainer?.zPosition = 1.0
            
            self._bgm.autoplayLooped = true
            self._scene.addChild(self._bgm)
            
            // Add the nodes to the scene
            self._scene.addChild(self._topUiContainer!)
            self._scene.addChild(self._bottomUiContainer!)
            self._scene.addChild(self._sampleBalloon!)
        }
        
        override func update(deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            
            let mathMasterRef = self._scene.gameMaster.mathMaster
            self._topUiContainer?.updateUiValues(mathMasterRef: mathMasterRef)
            self._bottomUiContainer?.updateUiValues(mathMasterRef: mathMasterRef)
//            self._sampleBalloon?.update(deltaTime: seconds)
            
            let (launchesRemaining, canLaunch) = mathMasterRef.tryBalloonLaunch()
            
            if launchesRemaining == .launchesRemaining && canLaunch {
                self._scene.addChild(ModernBalloon(mathMaster: mathMasterRef, sceneFrame: self._scene.frame))
            } else if launchesRemaining == .launchesExhausted {
                if self._scene.children.count <= 4 {
                    self.stateMachine?.enter(PLSEnding.self)
                }
            }
            
            for a in self._scene.children {
                if type(of: a) == ModernBalloon.self {
                    (a as! ModernBalloon).update(deltaTime: seconds)
                }
            }
        }
        
        override func willExit(to nextState: GKState) {
            // TODO: Codify these values in settings elsewhere in code
            let bgmActions = SKAction.sequence([
                SKAction.changeVolume(to: 0.0, duration: 2.0),
                SKAction.run {
                    self._bgm.removeFromParent()
                }
            ])
            let topUiContainerActions = SKAction.moveTo(x: 2000.0, duration: 2.0)
            let bottomUiContainerActions = SKAction.moveTo(x: -2000.0, duration: 2.0)
            
            self._scene.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.group([
                    SKAction.run {
                        self._bgm.run(bgmActions)
                    },
                    SKAction.run {
                        self._topUiContainer?.run(topUiContainerActions)
                    },
                    SKAction.run {
                        self._bottomUiContainer?.run(bottomUiContainerActions)
                    }
                ]),
                SKAction.run {
                    // This may result in super inefficient code, but I'm going to run with it for the time being
                    self._bgm.removeFromParent()
                    self._topUiContainer?.removeFromParent()
                    self._bottomUiContainer?.removeFromParent()
                }
            ]))
        }
    }
    
    class PLSEnding: SceneMinorState {
        override func didEnter(from previousState: GKState?) {
            let mathMasterRef = self._scene.gameMaster.mathMaster
            if mathMasterRef.hasPlayerWon() {
                // Display a set of nodes
                let congratsLabel: SKLabelNode = SKLabelNode(text: "Congratulations!")
                let nextLevelLabel: SKLabelNode = SKLabelNode(text: "Next Level?")
                let congratsVfx: SKAudioNode = SKAudioNode(fileNamed: "Voice You Win")
                
                congratsLabel.fontSize = 100.0
                congratsLabel.fontColor = .blue
                congratsLabel.position = CGPoint.zero
                nextLevelLabel.fontSize = 75.0
                nextLevelLabel.fontColor = .green
                nextLevelLabel.position = CGPoint(x: 0.0, y: -100.0)
                congratsVfx.autoplayLooped = false
                
                self._scene.addChild(congratsLabel)
                self._scene.addChild(nextLevelLabel)
                self._scene.addChild(congratsVfx)
            } else {
                // Display a different set of nodes
            }
        }
    }
    
    private var _ssm: GKStateMachine = GKStateMachine(states: [])
    
    private func buildFsm () {
        self._ssm = GKStateMachine(states: [
            PLSStarting(self),
            PLSStarted(self),
            PLSEnding(self)
        ])
    }
    
    override func sceneDidLoad() {
        self.buildFsm()
        self._ssm.enter(PLSStarting.self) // Deferred from the buildFsm function, where this is normally called
        self.scene?.scaleMode = .aspectFit
        self.scene?.backgroundColor = .black
    }
    
    override func update(_ currentTime: TimeInterval) {
        self._ssm.update(deltaTime: currentTime)
        
//        print("Number of children: \(self.scene!.children.count)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location)
        
        if ((frontTouchedNode.name?.contains("Balloon Top")) != nil) {
            if type(of: frontTouchedNode) == GMBalloonTop.self {
                let mbs: ModernBalloon = frontTouchedNode.parent as! ModernBalloon
                mbs.fsm.enter(ModernBalloon.MBSPopped.self)
            }
        }
    }
}
