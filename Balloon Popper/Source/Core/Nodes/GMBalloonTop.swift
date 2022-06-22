//
//  GMBalloonTop.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/20/22.
//

import GameplayKit
import SpriteKit

///
/// States that are used for the top balloon sprite.
///
class GMBalloonTopState: GKState {
    internal var _balloonTopSprite: GMBalloonTop
    
    init(_ bs: GMBalloonTop) {
        self._balloonTopSprite = bs
    }
    
    override func willExit(to nextState: GKState) {
        self._balloonTopSprite.removeAllActions()
    }
}

class GMBalloonTop: GMSpriteNode {
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
        self._fsm.enter(GMBalloonTop.BTSAlive.self)
    }
}
