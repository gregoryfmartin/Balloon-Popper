//
//  SplashScreenBear.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/26/22.
//

import Foundation
import SpriteKit
import GameplayKit

class SSBState : GKState {
    fileprivate var _ssb: SplashScreenBear
    
    init (_ ssb: SplashScreenBear) {
        self._ssb = ssb
    }
}

class SplashScreenBear : SKSpriteNode {
    class SSBSWalking : SSBState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == SSBSIdle.self
        }
        
        override func didEnter(from previousState: GKState?) {
            self._ssb.size.width = 75.0
            self._ssb.size.height = 62.0
            self._ssb.run(SKAction.group([
                self._ssb._animationsTable[.walkEast]!,
                self._ssb._actionsTable[.walkEast]!
            ]), withKey: SplashScreenBearAnimationNames.walkEast.rawValue)
        }
    }
    
    class SSBSIdle : SSBState {
        override func didEnter(from previousState: GKState?) {
            self._ssb.texture = self._ssb._walkEastFrames[1]
        }
    }
    
    enum SplashScreenBearAnimationNames: String, CaseIterable {
        case walkEast = "Walk East"
        case idleEast = "Idle East"
    }
    
    fileprivate var _walkEastFrames: [SKTexture] = []
    fileprivate var _animationsTable: [SplashScreenBearAnimationNames : SKAction] = [:]
    fileprivate var _actionsTable: [SplashScreenBearAnimationNames : SKAction] = [:]
    fileprivate var _pfsm: GKStateMachine = GKStateMachine(states: [])
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.buildFrames()
        self.buildAnimations()
        self.buildActions()
        self.buildFsm()
    }
    
    private func buildFrames () {
        let walkEastFrames = SKTextureAtlas(named: "Polar Bear")
        
        self._walkEastFrames.append(walkEastFrames.textureNamed("Walk East 0001"))
        self._walkEastFrames.append(walkEastFrames.textureNamed("Walk East 0002"))
        self._walkEastFrames.append(walkEastFrames.textureNamed("Walk East 0003"))
    }
    
    private func buildAnimations () {
        self._animationsTable[.walkEast] = SKAction.repeatForever(SKAction.animate(withNormalTextures: self._walkEastFrames, timePerFrame: 1.0, resize: false, restore: true))
    }
    
    private func buildActions () {
        self._actionsTable[.walkEast] = SKAction.moveTo(x: 0.0, duration: 5.0)
    }
    
    private func buildFsm () {
        self._pfsm = GKStateMachine(states: [
            SSBSWalking(self),
            SSBSIdle(self)
        ])
        self._pfsm.enter(SSBSWalking.self)
    }
    
    public func update (_ currentTime: TimeInterval) {
        self._pfsm.update(deltaTime: currentTime)
    }
}
