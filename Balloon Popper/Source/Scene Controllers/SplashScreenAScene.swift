//
//  SplashScreenAScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import SpriteKit

///
/// Splash Screen A is the first splash screen that is shown after the game launches. On iOS, this shows after the Launch Screen.
/// Splash Screen A shows the company logo. The style is meant to mimic the legacy Game Boy boot screen.
///
class SplashScreenAScene : GMScene {
    ///
    /// A reference to the label that shows the company logo.
    ///
    private var _labelOrgTitle: SKLabelNode? = nil
    
    override func sceneDidLoad() {
        // All we do here is linking the label reference in code to the entity created in the scene file.
        self._labelOrgTitle = self.childNode(withName: "\\labelOrgTitle") as? SKLabelNode
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if let label = self._labelOrgTitle {
            
            // The transition to the next state in the GM will occur six seconds after the label runs
            // out of actions.
            if !label.hasActions() {
                self.run(SKAction.wait(forDuration: 6.0))
                self.gameMaster.pfsm.enter(GameMaster.GMSSplashScreenB.self)
            }
        }
    }
}
