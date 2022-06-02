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
            
            // Add the MathMaster data to the correct nodes
            self._levelValue.text = String(mathMasterRef.currentLevel)
            
            // Provision the nodes
            // Most of this is going to be dynamic positioning.
            print("\(self._scene.frame.width) x  \(self._scene.frame.height)")
            
            self._topUiContainer = SKTopUiContainer(sceneFrameWidth: sceneFrameWidth, sceneFrameHeight: sceneFrameHeight)
            self._bottomUiContainer = SKBottomUiContainer(sceneFrameWidth: sceneFrameWidth, sceneFrameHight: sceneFrameHeight)
            
            // Add the nodes to the scene
            self._scene.addChild(self._topUiContainer!)
            self._scene.addChild(self._bottomUiContainer!)
        }
        
        override func update(deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            
            let mathMasterRef = self._scene.gameMaster.mathMaster
            self._topUiContainer?.updateUiValues(mathMasterRef: mathMasterRef)
            self._bottomUiContainer?.updateUiValues(mathMasterRef: mathMasterRef)
        }
    }
    
    class PLSEnding: SceneMinorState {}
    
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
        self._ssm.enter(PLSStarting.self)
        self.scene?.scaleMode = .aspectFit
    }
    
    override func update(_ currentTime: TimeInterval) {
        self._ssm.update(deltaTime: currentTime)
    }
}
