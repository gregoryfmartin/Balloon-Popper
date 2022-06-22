//
//  GMBalloonBottom.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/20/22.
//
//  TODO: A lot of this code needs refactored
//

import GameplayKit
import SpriteKit

///
/// States that are used for the bottom balloon sprite.
///
class GMBalloonBottomState: GKState {
    internal var _balloonBottomSprite: GMBalloonBottom
    
    init(_ bs: GMBalloonBottom) {
        self._balloonBottomSprite = bs
    }
    
    override func willExit(to nextState: GKState) {
        self._balloonBottomSprite.removeAllActions()
    }
}

class GMBalloonBottom: GMSpriteNode {
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
        self._actionsTable[.falling] = SKAction.moveTo(y: -1000.0, duration: 1.0)
    }
}
