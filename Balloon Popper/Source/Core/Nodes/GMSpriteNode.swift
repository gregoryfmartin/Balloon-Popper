//
//  GMSpriteNode.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/20/22.
//

import GameplayKit
import SpriteKit

///
/// Because I'm lazy and don't want to type all this out over and over again in each sprite. A base class will implement
/// these so they don't have to all be blindly repeated in each inheriting instance.
///
protocol GMSpriteCommons {
    func buildFrames() throws
    func buildActions() throws
    func buildAnimations() throws
    func configureFsms() throws
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

    internal var _direction: Int = 0
    internal var _movementSpeed: CGFloat = 0.0
    internal var _fsm: GKStateMachine = GKStateMachine(states: [])
    internal var _mathMasterRef: MathMaster?
    internal var _sceneFrame: CGRect?
    
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
    
    init(mathMaster mmr: MathMaster, sceneFrame sf: CGRect) {
        super.init(texture: nil, color: .white, size: .zero)

        self._mathMasterRef = mmr
        self._sceneFrame = sf
    }
}
