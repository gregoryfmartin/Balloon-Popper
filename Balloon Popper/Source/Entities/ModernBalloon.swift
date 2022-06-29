//
//  ModernBalloon.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/5/22.
//

import GameplayKit
import SpriteKit

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

class ModernBalloon: GMSpriteNode {    
    class MBSAlive: GMBalloonState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MBSPopped.self
        }
        
        override func didEnter(from previousState: GKState?) {
            // Make this thing move upward constantly
            self._balloonSprite.run(SKAction.moveTo(y: 1000.0, duration: CGFloat.random(in: 5.0...15.0)))
        }
        
        override func update(deltaTime seconds: TimeInterval) {
            super.update(deltaTime: seconds)
            
            // TODO: Check to see if we've floated above the viewport
        }
    }
    
    class MBSPopped: GMBalloonState {
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
            return stateClass == MBSDead.self
        }
        
        override func didEnter(from previousState: GKState?) {
            self._balloonSprite._balloonTop?.fsm.enter(GMBalloonTop.BTSDead.self)
            self._balloonSprite._balloonBottom?.fsm.enter(GMBalloonBottom.BBSFalling.self)
            self._balloonSprite._mathMasterRef?.currentScore += 5  // TODO: Make the score a computed property rather than a literal
            self._balloonSprite._mathMasterRef?.numBalloonsTapped += 1
            self._balloonSprite.size = CGSize.zero
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
            self._balloonSprite.removeAllActions()
            self._balloonSprite.removeFromParent()
        }
    }

    fileprivate var _balloonTop: GMBalloonTop?
    fileprivate var _balloonBottom: GMBalloonBottom?
    
    public var balloonTop: GMBalloonTop {
        get {
            return self._balloonTop!
        }
    }
    
    public var balloonBottom: GMBalloonBottom {
        get {
            return self._balloonBottom!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @available(*, unavailable)
    override init(mathMaster mmr: MathMaster) {
        super.init(mathMaster: mmr)
        
        // Create new instances of the top and bottom components
        self._balloonTop = GMBalloonTop(mathMaster: mmr);
        self._balloonBottom = GMBalloonBottom(mathMaster: mmr);
        
        self._balloonTop?.scale(to: CGSize(width: 128.0, height: 128.0))
        self._balloonBottom?.scale(to: CGSize(width: 128.0, height: 128.0))
        
        // Combine the two balloon parts into one
        self.addChild(self._balloonTop!)
        self.addChild(self._balloonBottom!)
        
        // Adjust the dimensions
        self.size.width = 128.0
        self.size.height = 256.0
        self.color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.zPosition = 0.5
        self.position = CGPoint(x: CGFloat.random(in: self.size.width...((self.scene?.frame.width)! - self.size.width)), y: -((self.scene?.frame.height)! / 2.0) - 100.0)
        
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
    
    override init(mathMaster mmr: MathMaster, sceneFrame sf: CGRect) {
        super.init(mathMaster: mmr, sceneFrame: sf)
        
        // Create new instances of the top and bottom components
        self._balloonTop = GMBalloonTop(mathMaster: mmr);
        self._balloonBottom = GMBalloonBottom(mathMaster: mmr);
        
        self._balloonTop?.scale(to: CGSize(width: 128.0, height: 128.0))
        self._balloonBottom?.scale(to: CGSize(width: 128.0, height: 128.0))
        
        // Combine the two balloon parts into one
        self.addChild(self._balloonTop!)
        self.addChild(self._balloonBottom!)
        
        // Adjust the dimensions
        // This may not be necessary
        self.size.width = 128.0
        self.size.height = 256.0
        self.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.zPosition = 0.5
//        self.position = CGPoint(x: CGFloat.random(in: -(self._sceneFrame!.width / 2.0)...((self._sceneFrame?.width)! - self.size.width)), y: -((self._sceneFrame?.height)! / 2.0) - 100.0)
        let leftMargin: CGFloat = (-(self._sceneFrame!.width / 2.0) + (self.size.width / 2.0) + 10.0)
        let rightMargin: CGFloat = ((self._sceneFrame!.width / 2.0) - (self.size.width / 2.0) - 10.0)
        self.position = CGPoint(x: CGFloat.random(in: leftMargin...rightMargin), y: -((self._sceneFrame!.height / 2.0) + 60.0))
        
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
