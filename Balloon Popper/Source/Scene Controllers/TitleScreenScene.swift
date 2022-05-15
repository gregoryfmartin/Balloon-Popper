//
//  TitleScreenScene.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 4/25/22.
//

import Foundation
import SwiftUI // This needs included for the touch event recognition, otherwise UITouch and UIEvent can't be found
import SpriteKit

///
/// Title Screen Scene shows the title screen scene. This scene is a hub of sorts that allows the player to do one of three things: open the Options scene, open the Credits scene, or start the game by opening the "Arena" scene.
///
class TitleScreenScene : GMScene {
    ///
    /// A reference to the label that shows the Options text.
    ///
    private var _labelOptions: SKLabelNode? = nil
    
    ///
    /// A reference to the label that shows the Credits test.
    ///
    private var _labelCredits: SKLabelNode? = nil
    
    private var _labelPlay: SKLabelNode? = nil
    
    ///
    /// A SKAudioNode that will be dynamically placed in the scene that will play the background audio. The decision to use a dynamic instance of this object instead of placing it in the scene using the Scene Editor was because it seemed too difficult to obtain a reference to it using usual methods. The usual method - illustrated when obtaining a reference to the labels above in the sceneDidLoad function - would fail to obtain the SKAudioNode reference depsite the fact that everything seemed to be correct otherwise.
    ///
    private var _audioBgm: SKAudioNode = SKAudioNode(fileNamed: "Title Screen Music B")
    
    override func sceneDidLoad() {
        // Obtain a reference to the labelOptions node.
        self._labelOptions = self.childNode(withName: "\\labelOptions") as! SKLabelNode?
        
        // Obtain a reference to the labelCredits node.
        self._labelCredits = self.childNode(withName: "\\labelCredits") as! SKLabelNode?
        
        self._labelPlay = self.childNode(withName: "\\labelPlay") as! SKLabelNode?
        
        // Set some properties for the background music node, then add it to the parent.
        self._audioBgm.autoplayLooped = true
//        self._audioBgm.run(SKAction.changeVolume(to: 0.1, duration: 0.0))
        self.addChild(self._audioBgm)
    }
    
    ///
    /// Override this function to enable touch detection.
    ///
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Some of the technique used here for isolating the touch event information is taken directly from Apple's documentation regarding this functionality.
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let frontTouchedNode = atPoint(location).name
        
        // If the touched node is the labelOptions node (obtained by name through frontTouchedNode), run a blink-like animation, play the VFX for the Options selection, and once that VFX is done, trigger a state transition in the GameMaster to the Options scene.
        if frontTouchedNode == "labelOptions" {
            self._labelOptions?.run(SKAction.group([
                SKAction.repeatForever(SKAction.init(named: "TitleItemFlash")!),
                SKAction.sequence([
                    SKAction.playSoundFileNamed("Voice Options", waitForCompletion: true),
                    SKAction.run {
                        self.gameMaster.pfsm.enter(GMSOptionsScreen.self)
                    }
                ])
            ]))
        }
        
        // If the touched node is the labelCredits node (obtained by name through frontTouchedNode), run a blink-like animation, play the VFX for the Credits selection, and once that VFX is done, trigger a state transition in the GameMaster to the Credits scene.
        if frontTouchedNode == "labelCredits" {
            self._labelCredits?.run(SKAction.group([
                SKAction.repeatForever(SKAction.init(named: "TitleItemFlash")!),
                SKAction.sequence([
                    SKAction.playSoundFileNamed("Voice Credits", waitForCompletion: true),
                    SKAction.run {
                        self.gameMaster.pfsm.enter(GMSCreditsScreen.self)
                    }
                ])
            ]))
        }
        
        // If the touched node is the labelPlay node (obtained by name through frontTouchedNode), run a blink-like animation, play the VFX for the Play selection, and once that VFX is done, trigger a state transition in the GameMaster to the Credits scene.
        if frontTouchedNode == "labelPlay" {
            self._labelPlay?.run(SKAction.group([
                SKAction.repeatForever(SKAction.init(named: "TitleItemFlash")!),
                SKAction.sequence([
                    SKAction.playSoundFileNamed("Voice Continue", waitForCompletion: true),
                    SKAction.run {
                        self.gameMaster.pfsm.enter(GMSPlayLevel.self)
                    }
                ])
            ]))
        }
        
//        print("Touched node: \(String(describing: frontTouchedNode))")
    }
}
