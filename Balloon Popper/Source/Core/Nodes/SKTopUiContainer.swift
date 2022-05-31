//
//  SKTopUiContainer.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/29/22.
//

import SpriteKit

class SKTopUiContainer: SKShapeNode {
    private static let CONTAINER_HEIGHT_SCALAR            : CGFloat = 0.075
    private static let LEVEL_LABEL_DEFAULT_TEXT           : String  = "Level"
    private static let LEVEL_VALUE_DEFAULT_TEXT           : String  = ""
    private static let BALLOONS_TO_TAP_LABEL_DEFAULT_TEXT : String  = "To Pop"
    private static let BALLOONS_TO_TAP_VALUE_DEFAULT_TEXT : String  = ""
    private static let BALLOONS_TAPPED_LABEL_DEFAULT_TEXT : String  = "Popped"
    private static let BALLOONS_TAPPED_VALUE_DEFAULT_TEXT : String  = ""
    private static let RECT_FRAME_DEBUG_LINE_WIDTH        : CGFloat = 1.0
    private static let VALUE_LABEL_FONT_SIZE              : CGFloat = 64.0
    private static let HORIZONTAL_PADDING                 : CGFloat = 5.0

    private var _slabA               : SKShapeNode = SKShapeNode()
    private var _slabB               : SKShapeNode = SKShapeNode()
    private var _slabC               : SKShapeNode = SKShapeNode()
    private var _levelLabel          : SKLabelNode = SKLabelNode(text : SKTopUiContainer.LEVEL_LABEL_DEFAULT_TEXT)
    private var _levelValue          : SKLabelNode = SKLabelNode(text : SKTopUiContainer.LEVEL_VALUE_DEFAULT_TEXT)
    private var _balloonsToTapLabel  : SKLabelNode = SKLabelNode(text : SKTopUiContainer.BALLOONS_TO_TAP_LABEL_DEFAULT_TEXT)
    private var _balloonsToTapValue  : SKLabelNode = SKLabelNode(text : SKTopUiContainer.BALLOONS_TO_TAP_VALUE_DEFAULT_TEXT)
    private var _balloonsTappedLabel : SKLabelNode = SKLabelNode(text : SKTopUiContainer.BALLOONS_TAPPED_LABEL_DEFAULT_TEXT)
    private var _balloonsTappedValue : SKLabelNode = SKLabelNode(text : SKTopUiContainer.BALLOONS_TAPPED_VALUE_DEFAULT_TEXT)

    private var _sceneFrameWidth  : CGFloat = 0.0
    private var _sceneFrameHeight : CGFloat = 0.0

    ///
    /// This is required but never used
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(sceneFrameWidth sfw: CGFloat, sceneFrameHeight sfh: CGFloat) {
        super.init()
        self._sceneFrameWidth  = sfw
        self._sceneFrameHeight = sfh
        let myHeight: CGFloat  = self._sceneFrameHeight * SKTopUiContainer.CONTAINER_HEIGHT_SCALAR

        /*
         * Step 1 - Create the container rectangle
         * Step 2 - Based on the width of the container rectangle, create three
         *          smaller rectangles and add them into the container
         *          in sequence.
         * Step 3 - Insert the current level nodes into Slab A and provision them
         * Step 4 - Insert the Balloons To Tap nodes into Slab B and provision them
         * Step 5 - Insert the Balloons Tapped nodes into Slab C and provision them
         */
        // This technique allows you to create a shape for a SKShapeNode
        // in an extended context.
        // This was derived from an Apple Developer page
        // (https://developer.apple.com/forums/thread/43754)
        let mutRect: CGMutablePath = CGMutablePath()
        mutRect.addRect(CGRect(x: 0.0, y: 0.0, width: self._sceneFrameWidth, height: myHeight))
        self.path      = mutRect
        self.position  = CGPoint(x: -(self._sceneFrameWidth / 2.0), y: (self._sceneFrameHeight / 2.0) - myHeight)
        self.lineWidth = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH

        // Create the three stubs
        // Divide the width of the container by 3, use this value as the
        // width for the slabs. Also use it for placement guidance in
        // the container along the x axis
        let slabDivider: CGFloat = self.frame.width / 3.0
        let sarect: CGMutablePath = CGMutablePath()
        sarect.addRect(CGRect(x: 0.0, y: 0.0, width: slabDivider, height: myHeight))
        self._slabA.path        = sarect
        self._slabA.lineWidth   = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabA.strokeColor = .red
        self.addChild(self._slabA)
        self._slabA.position = CGPoint.zero

        let sbrect: CGMutablePath = CGMutablePath()
        sbrect.addRect(CGRect(x: 0.0, y: 0.0, width: slabDivider, height: myHeight))
        self._slabB.path        = sbrect
        self._slabB.lineWidth   = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabB.strokeColor = .green
        self.addChild(self._slabB)
        self._slabB.position = CGPoint(x: slabDivider, y: 0.0)

        let screct: CGMutablePath = CGMutablePath()
        screct.addRect(CGRect(x: 0.0, y: 0.0, width: slabDivider, height: myHeight))
        self._slabC.path        = screct
        self._slabC.lineWidth   = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabC.strokeColor = .blue
        self.addChild(self._slabC)
        self._slabC.position = CGPoint(x: slabDivider * 2.0, y: 0.0)

        // Add the UI elements to Slab A
        self._slabA.addChild(self._levelLabel)
        self._slabA.addChild(self._levelValue)
        self._levelLabel.fontColor = .yellow
        self._levelValue.fontSize  = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slaXHalved: CGFloat    = self._slabA.frame.width / 2.0
        self._levelLabel.position  = CGPoint(x: slaXHalved, y: (myHeight - self._levelLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._levelValue.position  = CGPoint(x: slaXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)

        // Add the UI elements to Slab B
        self._slabB.addChild(self._balloonsToTapLabel)
        self._slabB.addChild(self._balloonsToTapValue)
        self._balloonsToTapLabel.fontColor = .yellow
        self._balloonsToTapValue.fontSize  = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slbXHalved: CGFloat            = self._slabB.frame.width / 2.0
        self._balloonsToTapLabel.position  = CGPoint(x: slbXHalved, y: (myHeight - self._balloonsToTapLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._balloonsToTapValue.position  = CGPoint(x: slbXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)

        // Add the UI elements to Slab C
        self._slabC.addChild(self._balloonsTappedLabel)
        self._slabC.addChild(self._balloonsTappedValue)
        self._balloonsTappedLabel.fontColor = .yellow
        self._balloonsTappedValue.fontSize  = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slcXHalved: CGFloat             = self._slabC.frame.width / 2.0
        self._balloonsTappedLabel.position  = CGPoint(x: slcXHalved, y: (myHeight - self._balloonsTappedLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._balloonsTappedValue.position  = CGPoint(x: slcXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)
    }

    public func updateUiValues(mathMasterRef mmr: MathMaster) {
        self._levelValue.text          = String(mmr.currentLevel)
        self._balloonsToTapValue.text  = String(mmr.numBalloonsToPop)
        self._balloonsTappedValue.text = String(mmr.numBalloonsTapped)
    }
}
