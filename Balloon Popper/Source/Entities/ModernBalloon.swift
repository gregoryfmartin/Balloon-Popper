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
        fileprivate var _actionsTable: [GMBalloonTopState : SKAction] = [:]
        fileprivate var _animationsTable: [GMBalloonTopState : SKAction] = [:]
        
        class BTSAlive: GMBalloonTopState {
            override func isValidNextState(_ stateClass: AnyClass) -> Bool {
                return stateClass == BTSDead.self
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
            self.texture = possiblesAtlas.textureNamed(possiblesAtlas.textureNames[possiblesSelection])
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
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(mathMaster mmr: MathMaster) {
            super.init(mathMaster: mmr)
            
            let possiblesDirection: Bool = Bool.random() // true = left, false = right
            var possiblesAtlas: SKTextureAtlas? = nil
            if possiblesDirection {
                possiblesAtlas = SKTextureAtlas(named: "Balloon Bottoms Left")
            } else {
                possiblesAtlas = SKTextureAtlas(named: "Balloon Bottoms Right")
            }
            let possiblesTotal: Int = possiblesAtlas!.textureNames.count - 1
            let possiblesSelection: Int = Int.random(in: 0 ... possiblesTotal)
            self.texture = possiblesAtlas!.textureNamed(possiblesAtlas!.textureNames[possiblesSelection])
        }
    }

    fileprivate var _balloonTop: BalloonTop?
    fileprivate var _balloonBottom: BalloonBottom?
}
