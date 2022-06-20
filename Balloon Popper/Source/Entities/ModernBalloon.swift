//
//  ModernBalloon.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/5/22.
//

import GameplayKit
import SpriteKit

///
/// A sample implementation of the Error type that simply lets a caller know that a function isn't implemented.
///
enum GMExceptions: Error {
    case funcNotImplemented
}

///
/// Because I'm lazy and don't want to type all this out over and over again in each sprite.
///
protocol GMSpriteCommons {
    func buildFrames() throws
    func buildActions() throws
    func buildAnimations() throws
    func configureFsms() throws
}

///
/// States that are used for the balloon container itself.
///
class GMBalloonState: GKState {
    fileprivate var _balloonSprite: ModernBalloon

    init(_ bs: ModernBalloon) {
        self._balloonSprite = bs
    }

    override func willExit(to nextState: GKState) {
        self._balloonSprite.removeAllActions()
    }
}

///
/// States that are used for the top balloon sprite.
///
class GMBalloonTopState: GKState {
    fileprivate var _balloonTopSprite: ModernBalloon.BalloonTop
    
    init(_ bs: ModernBalloon.BalloonTop) {
        self._balloonTopSprite = bs
    }
    
    override func willExit(to nextState: GKState) {
        self._balloonTopSprite.removeAllActions()
    }
}

///
/// States that are used for the bottom balloon sprite.
///
class GMBalloonBottomState: GKState {
    fileprivate var _balloonBottomSprite: ModernBalloon.BalloonBottom
    
    init(_ bs: ModernBalloon.BalloonBottom) {
        self._balloonBottomSprite = bs
    }
    
    override func willExit(to nextState: GKState) {
        self._balloonBottomSprite.removeAllActions()
    }
}

///
/// My custom SKSpriteNode extension that incorporates a FSM, common functions, and a reference to the Math Master (specific to this game).
///
class GMSpriteNode: SKSpriteNode, GMSpriteCommons {
    func buildFrames() throws {
        throw GMExceptions.funcNotImplemented
    }

    func buildActions() throws {
        throw GMExceptions.funcNotImplemented
    }

    func buildAnimations() throws {
        throw GMExceptions.funcNotImplemented
    }

    func configureFsms() throws {
        throw GMExceptions.funcNotImplemented
    }

    fileprivate var _direction: Int = 0
    fileprivate var _movementSpeed: CGFloat = 0.0
    fileprivate var _fsm: GKStateMachine = GKStateMachine(states: [])
    fileprivate var _mathMasterRef: MathMaster?
    
    public var direction: Int {
        get {
            return self._direction
        }
    }
    
    public var movementSpeed: CGFloat {
        get {
            return self._movementSpeed
        }
    }
    
    public var fsm: GKStateMachine {
        get {
            return self._fsm
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(mathMaster mmr: MathMaster) {
        super.init(texture: nil, color: .white, size: .zero)

        self._mathMasterRef = mmr
    }
}

class ModernBalloon: GMSpriteNode {
    class BalloonTop: GMSpriteNode {
        private var _texture: SKTexture? = nil
        
//        fileprivate var _actionsTable: [GMBalloonTopState : SKAction] = [:]
//        fileprivate var _animationsTable: [GMBalloonTopState : SKAction] = [:]
        
        class BTSAlive: GMBalloonTopState {
            override func isValidNextState(_ stateClass: AnyClass) -> Bool {
                return stateClass == BTSDead.self
            }
            
            override func didEnter(from previousState: GKState?) {
                self._balloonTopSprite.texture = self._balloonTopSprite._texture
                self._balloonTopSprite.size.width = 32.0
                self._balloonTopSprite.size.height = 32.0
            }
        }
        
        class BTSDead: GMBalloonTopState {
            override func didEnter(from previousState: GKState?) {
                let action: SKAction = SKAction.group([
                    SKAction.playSoundFileNamed("Balloon Pop C", waitForCompletion: false),
                    SKAction.sequence([
                        SKAction.fadeOut(withDuration: 0.1),
                        SKAction.run {
                            self._balloonTopSprite.removeFromParent()
                        }
                    ])
                ])
                
                self._balloonTopSprite.run(action)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override init(mathMaster mmr: MathMaster) {
            super.init(mathMaster: mmr)
            
            self.name = "Balloon Top"
            
            do {
                try self.buildFrames()
                try self.configureFsms()
            } catch GMExceptions.funcNotImplemented {
                print("This function call isn't implemented in this class!")
            } catch {
                print("A generic exception was encountered!")
            }
        }
        
        override func buildFrames() throws {
            let possiblesAtlas: SKTextureAtlas = SKTextureAtlas(named: "Balloon Tops")
            let possiblesTotal: Int = possiblesAtlas.textureNames.count - 1
            let possiblesSelection: Int = Int.random(in: 0 ... possiblesTotal)
            self._texture = possiblesAtlas.textureNamed(possiblesAtlas.textureNames[possiblesSelection])
        }
        
        override func configureFsms() throws {
            self._fsm = GKStateMachine(states: [
                BTSAlive(self),
                BTSDead(self)
            ])
            self._fsm.enter(BalloonTop.BTSAlive.self)
        }
    }

    class BalloonBottom: GMSpriteNode {
        private var _texture: SKTexture? = nil
        
        // This is required because "Type" can't be Hashable. This is bullshit.
        enum BalloonBottomPossibleStates {
            case alive
            case falling
            case dead
        }
        
        fileprivate var _actionsTable: [BalloonBottomPossibleStates : SKAction] = [:]
        fileprivate var _animationsTable: [BalloonBottomPossibleStates : SKAction] = [:]
        
        class BBSAlive: GMBalloonBottomState {
            override func isValidNextState(_ stateClass: AnyClass) -> Bool {
                return stateClass == BBSFalling.self
            }
            
            override func didEnter(from previousState: GKState?) {
                self._balloonBottomSprite.texture = self._balloonBottomSprite._texture
                self._balloonBottomSprite.size.width = 32.0
                self._balloonBottomSprite.size.height = 32.0
            }
        }
        
        class BBSFalling: GMBalloonBottomState {
            override func isValidNextState(_ stateClass: AnyClass) -> Bool {
                return stateClass == BBSDead.self
            }
            
            override func didEnter(from previousState: GKState?) {
                let fallingAction: SKAction = SKAction.moveTo(y: -2000.0, duration: 1.5)
                fallingAction.timingMode = .easeIn
                let action: SKAction = SKAction.group([
                    SKAction.playSoundFileNamed("Balloon Basket Falling", waitForCompletion: false),
                    fallingAction
                ])
                self._balloonBottomSprite.run(action)
            }
            
            override func update(deltaTime seconds: TimeInterval) {
                super.update(deltaTime: seconds)
                
                if self._balloonBottomSprite.position.y <= -2000.0 {
                    self._balloonBottomSprite.removeAllActions()
                    self.stateMachine?.enter(BBSDead.self)
                }
            }
        }
        
        class BBSDead: GMBalloonBottomState {
            override func didEnter(from previousState: GKState?) {
                // Remove this node from the parent's scene graph
                self._balloonBottomSprite.removeFromParent()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(mathMaster mmr: MathMaster) {
            super.init(mathMaster: mmr)
            
            self.name = "Balloon Bottom"
            
            do {
                try self.buildFrames()
                try self.configureFsms()
                try self.buildActions()
            } catch GMExceptions.funcNotImplemented {
                print("This function call isn't implemented in this class!")
            } catch {
                print("A generic exception was encountered!")
            }
        }
        
        override func buildFrames() throws {
            let possiblesDirection: Bool = Bool.random() // true = left, false = right
            var possiblesAtlas: SKTextureAtlas? = nil
            if possiblesDirection {
                possiblesAtlas = SKTextureAtlas(named: "Balloon Bottoms Left")
            } else {
                possiblesAtlas = SKTextureAtlas(named: "Balloon Bottoms Right")
            }
            let possiblesTotal: Int = possiblesAtlas!.textureNames.count - 1
            let possiblesSelection: Int = Int.random(in: 0 ... possiblesTotal)
            self._texture = possiblesAtlas!.textureNamed(possiblesAtlas!.textureNames[possiblesSelection])
        }
        
        override func configureFsms() throws {
            self._fsm = GKStateMachine(states: [
                BBSAlive(self),
                BBSFalling(self),
                BBSDead(self)
            ])
            self._fsm.enter(BBSAlive.self)
        }
        
        override func buildActions() throws {
            // This needs run with a ease in only
            self._actionsTable[.falling] = SKAction.moveTo(y: -1000.0, duration: 1.0)
        }
    }
    
    class MBSAlive: GMBalloonState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MBSPopped.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Make this thing move upward constantly
            self._balloonSprite.run(SKAction.moveTo(y: 1000.0, duration: CGFloat.random(in: 5.0...15.0)))
        }
    }
    
    class MBSPopped: GMBalloonState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MBSDead.self
        }
        
        override func didEnter(from previousState: GKState?) {
            self._balloonSprite._balloonTop?.fsm.enter(ModernBalloon.BalloonTop.BTSDead.self)
            self._balloonSprite._balloonBottom?.fsm.enter(ModernBalloon.BalloonBottom.BBSFalling.self)
        }
        
        override func update(deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            
            if self._balloonSprite.children.count <= 0 {
                self.stateMachine?.enter(MBSDead.self)
            }
        }
    }
    
    class MBSDead: GMBalloonState {
        override func didEnter(from previousState: GKState?) {
            self._balloonSprite.removeFromParent()
        }
    }

    fileprivate var _balloonTop: BalloonTop?
    fileprivate var _balloonBottom: BalloonBottom?
    
    public var balloonTop: BalloonTop {
        get {
            return self._balloonTop!
        }
    }
    
    public var balloonBottom: BalloonBottom {
        get {
            return self._balloonBottom!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(mathMaster mmr: MathMaster) {
        super.init(mathMaster: mmr)
        
        // Create new instances of the top and bottom components
        self._balloonTop = BalloonTop(mathMaster: mmr);
        self._balloonBottom = BalloonBottom(mathMaster: mmr);
        
        self._balloonTop?.scale(to: CGSize(width: 128.0, height: 128.0))
        self._balloonBottom?.scale(to: CGSize(width: 128.0, height: 128.0))
        
        // Combine the two balloon parts into one
        self.addChild(self._balloonTop!)
        self.addChild(self._balloonBottom!)
        
        // Adjust the dimensions
        self.size.width = 128.0
        self.size.height = 256.0
        self.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.zPosition = 0.5
        
        // Reposition the components
        self._balloonTop?.position = CGPoint(x: 0.0, y: 0.0)
        self._balloonBottom?.position = CGPoint(x: 0.0, y: -128.0)
        
        do {
            try self.configureFsms()
        } catch GMExceptions.funcNotImplemented {
            print("This function call isn't implemented in this class!")
        } catch {
            print("A generic exception was encountered!")
        }
    }
    
    override func configureFsms() throws {
        self._fsm = GKStateMachine(states: [
            MBSAlive(self),
            MBSPopped(self),
            MBSDead(self)
        ])
        self._fsm.enter(MBSAlive.self)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        self._fsm.update(deltaTime: seconds)
        self._balloonBottom?.fsm.update(deltaTime: seconds)
        self._balloonTop?.fsm.update(deltaTime: seconds)
    }
}
