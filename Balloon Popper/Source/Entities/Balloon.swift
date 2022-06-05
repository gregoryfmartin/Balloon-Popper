//
//  Balloon.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/22/22.
//

import Foundation
import GameplayKit
import SpriteKit

class BalloonStates : GKState {
    fileprivate var _balloonSprite: Balloon
    
    init (_ bs: Balloon) {
        self._balloonSprite = bs
    }
    
    override func willExit(to nextState: GKState) {
        self._balloonSprite.removeAllActions()
    }
}

class Balloon : SKSpriteNode {
    ///
    /// The direction the Balloon is traveling in. 0 = north, 180 = south.
    ///
    fileprivate var _direction: Int = 0
    
    ///
    /// The interval at which changes in coordinates will occur.
    ///
    fileprivate var _movementSpeed: CGFloat = 0.0
    
    ///
    /// The frames that are used to animate the floating upward action.
    ///
    fileprivate var _floatingFrames: [SKTexture] = []
    
    ///
    /// The frames that are used to animate the pop action.
    ///
    fileprivate var _popFrames: [SKTexture] = []
    
    ///
    /// The primary state machine.
    ///
    fileprivate var _pfsm: GKStateMachine = GKStateMachine(states: [])
    
    ///
    /// A reference to the SKScene that the Balloon operates in.
    ///
    fileprivate var _sceneRef: GMScene? = nil
    
    ///
    /// The animation lookup table.
    ///
    fileprivate var _animationsTable: [BalloonSpriteAnimationNames : SKAction] = [:]
    
    ///
    /// The actions lookup table.
    ///
    fileprivate var _actionsTable: [BalloonSpriteAnimationNames : SKAction] = [:]
    
    ///
    /// Public accessor for _direction
    ///
    public var direction: Int {
        get {
            return self._direction
        }
    }
    
    ///
    /// Public accessor for _movementSpeed
    ///
    public var movementSpeed: CGFloat {
        get {
            return self._movementSpeed
        }
    }
    
    ///
    /// Public accessor for _pfsm
    ///
    public var pfsm: GKStateMachine {
        get {
            return self._pfsm
        }
    }
    
    ///
    /// A convenient way to refer to all of the possible animations that can be used by the Balloon.
    ///
    enum BalloonSpriteAnimationNames: String, CaseIterable {
        ///
        /// Specifies that the Balloon is using the Floating animation.
        ///
        case floating = "Floating"
        
        ///
        /// Specifies that the Balloon is using the Popped animation.
        ///
        case popped = "Popped"
        
        ///
        /// Specifies that the Balloon is using the Out of Bounds animation.
        ///
        case outOfBounds = "Out of Bounds"
        
        ///
        /// Specifies that the Balloon is using no animation.
        ///
        case none = "None"
    }
    
    ///
    /// A collection of speeds that are used for different animations.
    ///
    enum BalloonSpriteAnimationSpeeds: TimeInterval {
        case floatingAnimationSpeed = 0.12
        case poppedAnimationSpeed = 0.09
    }
    
    ///
    /// This is the default state of the balloon
    ///
    class BalloonStateNone : BalloonStates {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == BalloonStateFloating.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Ensure the initial state of the Balloon makes sense before continuing
            self._balloonSprite._direction = 0
            self._balloonSprite._movementSpeed = 5.0
        }
    }
    
    ///
    /// This is the state the balloon is in when it's floating toward the top of the screen.
    ///
    class BalloonStateFloating: BalloonStates {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == BalloonStatePopped.self ||
            stateClass == BalloonStateOob.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Ensure that the balloon is the correct size and can float upward
            
            // TODO: Set frame size of the sprite
            // TODO: Execute the action to float upward
        }
    }
    
    ///
    /// This is the state the balloon is in when it's been pressed on by the player.
    ///
    class BalloonStatePopped: BalloonStates {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == BalloonStateNone.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Ensure that the valloon is the correct size and can execute the pop animation
            
            // TODO: Set frame size of the sprite
            // TODO: Execute the action to pop
        }
    }
    
    ///
    /// This is the state the balloon is in when it's floated above the top boundary of the screen.
    ///
    class BalloonStateOob: BalloonStates {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == BalloonStateNone.self
        }
    }
    
    ///
    /// This is the intended initializer.
    ///
    init (scene aScene: GMScene) {
        super.init(texture: nil, color: .white, size: .zero)
        
        self._sceneRef = aScene
        
        self.buildFrames()
        self.buildActions()
        self.buildAnimations()
        self.configureFsms()
    }
    
    ///
    /// This initializer is required because of the inheritance of SKSpriteNode, but it's not intended to be used.
    ///
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    /// Contstruct the animation sequences from atlases.
    ///
    private func buildFrames () {
        let floatingAtlas = SKTextureAtlas(named: "Balloon Floating")
        let popAtlas = SKTextureAtlas(named: "Balloon Popped")
        
        // Load the floating animation frames
        for i in 1...floatingAtlas.textureNames.count {
            var tname = ""
            if i < 10 {
                tname = "Balloon Floating 00\(i)"
            } else {
                tname = "Balloon Floating 0\(i)"
            }
            self._floatingFrames.append(floatingAtlas.textureNamed(tname))
        }
        
        // Load the pop animation frames
        for i in 1...popAtlas.textureNames.count {
            var tname = ""
            if i < 10 {
                tname = "Balloon Popped 00\(i)"
            } else {
                tname = "Balloon Popped 0\(i)"
            }
            self._popFrames.append(popAtlas.textureNamed(tname))
        }
    }
    
    ///
    /// Construct the animation actions.
    ///
    private func buildAnimations () {
        self._animationsTable[.floating] = SKAction.repeatForever(SKAction.animate(with: self._floatingFrames, timePerFrame: BalloonSpriteAnimationSpeeds.floatingAnimationSpeed.rawValue, resize: false, restore: true))
        self._animationsTable[.popped] = SKAction.animate(with: self._popFrames, timePerFrame: BalloonSpriteAnimationSpeeds.poppedAnimationSpeed.rawValue, resize: false, restore: true)
    }
    
    ///
    /// Construct the actions.
    ///
    private func buildActions () {
        /*
         * A couple of notes here.
         *
         * First of all, it should be noted that the way the Balloon is currently constructed
         * restricts the movement pattern to only one kind, that being prescribed here.
         *
         * Second, in order to add some variation, the value for x in horizontalMovementActions,
         * the value for y in verticalMovementActions, and the value for duration at the end of
         * the grouping should be variable and be a function of both randomness at time of creation
         * and of the difficulty curve (when implemented).
         */
        let horizontalMovementActions = [
            SKAction.moveBy(x: 100.0, y: 0.0, duration: 1.0),
            SKAction.moveBy(x: -100.0, y: 0.0, duration: 1.0),
            SKAction.moveBy(x: -100.0, y: 0.0, duration: 1.0),
            SKAction.moveBy(x: 100.0, y: 0.0, duration: 1.0)
        ]
        let verticalMovementActions = [
            SKAction.moveBy(x: 0.0, y: 20.0, duration: 1.0),
            SKAction.moveBy(x: 0.0, y: -20.0, duration: 1.0),
            SKAction.moveBy(x: 0.0, y: 20.0, duration: 1.0),
            SKAction.moveBy(x: 0.0, y: -20.0, duration: 1.0)
        ]
        
        self._actionsTable[.popped] = SKAction.run {
//            self._sceneRef?.updateScore(5)
        }
        self._actionsTable[.outOfBounds] = SKAction.run {
//            self._sceneRef?.updateScore(-5)
        }
        self._actionsTable[.floating] = SKAction.repeatForever(
            SKAction.group([
                SKAction.sequence(horizontalMovementActions),
                SKAction.sequence(verticalMovementActions),
                SKAction.moveBy(x: 0.0, y: 500.0, duration: 25.0)
            ])
        )
    }
    
    ///
    /// Configure the FSMs.
    ///
    private func configureFsms () {
        self._pfsm = GKStateMachine(states: [
            BalloonStateNone(self),
            BalloonStateFloating(self),
            BalloonStatePopped(self),
            BalloonStateOob(self)
        ])
        self._pfsm.enter(BalloonStateNone.self)
    }
}
