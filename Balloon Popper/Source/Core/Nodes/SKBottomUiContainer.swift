//
//  SKBottomUiContainer.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 6/2/22.
//

import SpriteKit

///
/// This is the bottom UI container that's displayed in the Play Scene. It contains the current score and the button to bring up the in-game menu. It tries to be sensitive to the width of the scene on different screen sizes despite the aspect ratio being governed by the scene.
///
class SKBottomUiContainer: SKShapeNode {
    ///
    /// This scalar is multiplied by the height of the scene's frame to determine the height of this container.
    ///
    private static let CONTAINER_HEIGHT_SCALAR: CGFloat = 0.075
    
    ///
    /// The literal that's displayed above the Current Score Value label.
    ///
    private static let SCORE_LABEL_DEFAULT_TEXT: String = "Score"
    
    ///
    /// The default text to place in the Current Score Value label. This is really only intended to be used for debugging purposes.
    ///
    private static let SCORE_VALUE_DEFAULT_TEXT: String = "999999"
    
    ///
    /// The literal that's displayed above the Menu Value label.
    ///
    private static let MENU_LABEL_DEFAULT_TEXT: String = "Menu"
    
    ///
    /// The default text to place in the Menu Value label. This is really only intended to be used for debugging purposes.
    ///
    private static let MENU_VALUE_DEFAULT_TEXT: String = "⏸"
    
    ///
    /// The line width of the shape. This is really only intended to be used for debugging purposes.
    ///
    private static let RECT_FRAME_DEBUG_LINE_WIDTH: CGFloat = 1.0
    
    ///
    /// The font size that's used for the value labels.
    ///
    private static let VALUE_LABEL_FONT_SIZE: CGFloat = 64.0
    
    ///
    /// The padding that gets applied to the top and bottom of the container that pulls the elements closer together in the center.
    ///
    private static let HORIZONTAL_PADDING: CGFloat = 5.0
    
    ///
    /// The slab that gets placed in the far-left of the container. This contains the current score information.
    ///
    private var _slabA: SKShapeNode = SKShapeNode()
    
    ///
    /// The slab that gets placed in the far-right of the container. This contains the in-game menu button.
    ///
    private var _slabB: SKShapeNode = SKShapeNode()
    
    ///
    ///
    ///
    private var _scoreLabel: SKLabelNode = SKLabelNode(text: SKBottomUiContainer.SCORE_LABEL_DEFAULT_TEXT)
    private var _scoreValue: SKLabelNode = SKLabelNode(text: SKBottomUiContainer.SCORE_VALUE_DEFAULT_TEXT)
    private var _menuLabel: SKLabelNode = SKLabelNode(text: SKBottomUiContainer.MENU_LABEL_DEFAULT_TEXT)
    private var _menuValue: SKLabelNode = SKLabelNode(text: SKBottomUiContainer.MENU_VALUE_DEFAULT_TEXT)
    
    private var _sceneFrameWidth: CGFloat = 0.0
    private var _sceneFrameHeight: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(sceneFrameWidth sfw: CGFloat, sceneFrameHight sfh: CGFloat) {
        super.init()
        self._sceneFrameWidth = sfw
        self._sceneFrameHeight = sfh
        let myHeight: CGFloat = self._sceneFrameHeight * SKBottomUiContainer.CONTAINER_HEIGHT_SCALAR
        
        let mutRect: CGMutablePath = CGMutablePath()
        mutRect.addRect(CGRect(x: 0.0, y: 0.0, width: self._sceneFrameWidth, height: myHeight))
        self.path = mutRect
        self.position = CGPoint(x: -(self._sceneFrameWidth / 2.0), y: -(self._sceneFrameHeight / 2.0))
        self.lineWidth = SKBottomUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        
        let slabDivider: CGFloat = self.frame.width / 2.0
        
        createSlabA(slabDivider: slabDivider, myHeight: myHeight)
        createSlabB(slabDivider: slabDivider, myHeight: myHeight)
        
        populateSlabA(myHeight: myHeight)
        populateSlabB(myHeight: myHeight)
    }
    
    public func updateUiValues(mathMasterRef mmr: MathMaster) {
        self._scoreValue.text = String(mmr.currentScore)
    }
    
    private func createSlabA(slabDivider sd: CGFloat, myHeight mh: CGFloat) {
        let sarect: CGMutablePath = CGMutablePath()
        sarect.addRect(CGRect(x: 0.0, y: 0.0, width: sd, height: mh))
        self._slabA.path = sarect
        self._slabA.lineWidth = SKBottomUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabA.strokeColor = .red
        self.addChild(self._slabA)
        self._slabA.position = CGPoint.zero
    }
    
    private func createSlabB(slabDivider sd: CGFloat, myHeight mh: CGFloat) {
        let sbrect: CGMutablePath = CGMutablePath()
        sbrect.addRect(CGRect(x: 0.0, y: 0.0, width: sd, height: mh))
        self._slabB.path = sbrect
        self._slabB.lineWidth = SKBottomUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabB.strokeColor = .green
        self.addChild(self._slabB)
        self._slabB.position = CGPoint(x: sd, y: 0.0)
    }
    
    private func populateSlabA(myHeight mh: CGFloat) {
        self._slabA.addChild(self._scoreLabel)
        self._slabA.addChild(self._scoreValue)
        self._scoreLabel.fontColor = .yellow
        self._scoreValue.fontSize = SKBottomUiContainer.VALUE_LABEL_FONT_SIZE
        let slaXHalved: CGFloat = self._slabA.frame.width / 2.0
        self._scoreLabel.position = CGPoint(x: slaXHalved, y: (mh - self._scoreLabel.frame.height) - SKBottomUiContainer.HORIZONTAL_PADDING)
        self._scoreValue.position = CGPoint(x: slaXHalved, y: SKBottomUiContainer.HORIZONTAL_PADDING)
    }
    
    private func populateSlabB(myHeight mh: CGFloat) {
        self._slabB.addChild(self._menuLabel)
        self._slabB.addChild(self._menuValue)
        self._menuLabel.fontColor = .yellow
        self._menuValue.fontSize = SKBottomUiContainer.VALUE_LABEL_FONT_SIZE
        let slbXHalved: CGFloat = self._slabB.frame.width / 2.0
        self._menuLabel.position = CGPoint(x: slbXHalved, y: (mh - self._menuLabel.frame.height) - SKBottomUiContainer.HORIZONTAL_PADDING)
        self._menuValue.position = CGPoint(x: slbXHalved, y: SKBottomUiContainer.HORIZONTAL_PADDING)
    }
}
