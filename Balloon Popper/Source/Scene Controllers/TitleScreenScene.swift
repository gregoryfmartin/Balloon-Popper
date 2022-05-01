//
//  TitleScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI // This needs included for the touch event recognition, otherwise UITouch and UIEvent can't be found
import SpriteKit

class TitleScreenScene : GMScene {
    private var _lastUpdateTime: TimeInterval = 0.0
    private var _labelOptions: SKLabelNode? = nil
    private var _labelCredits: SKLabelNode? = nil
    private var _audioBgm: SKAudioNode = SKAudioNode(fileNamed: "Title Screen Music B")
    
    override func sceneDidLoad() {
        self._lastUpdateTime = 0.0
        self._labelOptions = self.childNode(withName: "\\labelOptions") as! SKLabelNode?
        self._labelCredits = self.childNode(withName: "\\labelCredits") as! SKLabelNode?
        self._audioBgm.autoplayLooped = true
        self._audioBgm.run(SKAction.changeVolume(to: 0.1, duration: 0.0))
        self.addChild(self._audioBgm)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self._lastUpdateTime == 0.0 {
            self._lastUpdateTime = currentTime
        }
        let dt = currentTime - self._lastUpdateTime
        
        self.gameMaster.pfsm.update(deltaTime: dt)
        
        self._lastUpdateTime = currentTime
    }
    
    ///
    /// Override this function to enable touch detection.
    ///
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        if frontTouchedNode == "labelOptions" {
            self._labelOptions?.run(SKAction.sequence([
                SKAction.playSoundFileNamed("Voice Options", waitForCompletion: true),
                SKAction.run {
                    self.gameMaster.pfsm.enter(GameMaster.GMSOptionsScreen.self)
                }
            ]))
//            self.gameMaster.pfsm.enter(GameMaster.GMSOptionsScreen.self)
        }
        if frontTouchedNode == "labelCredits" {
            self.gameMaster.pfsm.enter(GameMaster.GMSCreditsScreen.self)
        }
        
        print("Touched node: \(String(describing: frontTouchedNode))")
    }
}
