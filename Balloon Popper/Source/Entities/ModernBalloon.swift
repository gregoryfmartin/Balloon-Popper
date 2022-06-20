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
        
        class BTSDead: GMBalloonTopState {}
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override init(mathMaster mmr: MathMaster) {
            super.init(mathMaster: mmr)
            
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
        }
        
        class BBSDead: GMBalloonBottomState {
            override func didEnter(from previousState: GKState?) {
                // Remove this node from the parent's scene graph
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(mathMaster mmr: MathMaster) {
            super.init(mathMaster: mmr)
            
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
    }
    
    class MBSPopped: GMBalloonState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MBSDead.self
        }
    }
    
    class MBSDead: GMBalloonState {}

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
        self.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        // Reposition the components
        self._balloonTop?.position = CGPoint(x: 0.0, y: 0.0)
        self._balloonBottom?.position = CGPoint(x: 0.0, y: -128.0)
        
        // Make this thing move upward constantly
        self.run(SKAction.moveTo(y: 1000.0, duration: 10.0))
    }
}
