//
//  SKTopUiContainer.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/29/22.
//

import SpriteKit

///
/// This is the top UI container that's displayed in the Play Scene. It contains the current level, the number of balloons to tap for the current level, and the current number of tapped balloons. It tries to be sensitive to the width of the scene on different screen sizes despite the aspect ratio being governed by the scene.
///
class SKTopUiContainer: SKShapeNode {
    ///
    /// This scalar is multiplied by the height of the scene's frame to determine the height of this container.
    ///
    private static let CONTAINER_HEIGHT_SCALAR: CGFloat = 0.075

    ///
    /// The literal that's displayed above the Current Level Value label.
    ///
    private static let LEVEL_LABEL_DEFAULT_TEXT: String = "Level"

    ///
    /// The default text to place in the Current Level Value label. This is really only intended to be used for debugging purposes.
    ///
    private static let LEVEL_VALUE_DEFAULT_TEXT: String = ""

    ///
    /// The literal that is displayed above the Current Pop Threshold Value label.
    ///
    private static let BALLOONS_TO_TAP_LABEL_DEFAULT_TEXT: String = "To Pop"

    ///
    /// The default text to place in the Current Pop Threshold Value label. This is really only intended to be used for debugging purposes.
    ///
    private static let BALLOONS_TO_TAP_VALUE_DEFAULT_TEXT: String = ""

    ///
    /// The literal that is displayed above the Current Popped Counter Value label.
    ///
    private static let BALLOONS_TAPPED_LABEL_DEFAULT_TEXT: String = "Popped"

    ///
    /// The default text to place in the Current Popped Counter Value label. This is really only intended to be used for debugging purposes.
    ///
    private static let BALLOONS_TAPPED_VALUE_DEFAULT_TEXT: String = ""

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
    /// The slab that gets placed on the far-left of the container. This contains the current level information.
    ///
    private var _slabA: SKShapeNode = SKShapeNode()

    ///
    /// The slab that gets placed in the middle of the container. This contains the current balloon tap threshold information.
    ///
    private var _slabB: SKShapeNode = SKShapeNode()

    ///
    /// The slab that gets placed on the far-right of the container. This contains the current balloons tapped information.
    ///
    private var _slabC: SKShapeNode = SKShapeNode()

    ///
    /// The SKLabelNode that shows the text "Level"
    ///
    private var _levelLabel: SKLabelNode = SKLabelNode(text: SKTopUiContainer.LEVEL_LABEL_DEFAULT_TEXT)

    ///
    /// The SKLabelNode that shows the current level. This value is taken from the Math Master.
    ///
    private var _levelValue: SKLabelNode = SKLabelNode(text: SKTopUiContainer.LEVEL_VALUE_DEFAULT_TEXT)

    ///
    /// The SKLabelNode that shows the text "To Pop".
    ///
    private var _balloonsToTapLabel: SKLabelNode = SKLabelNode(text: SKTopUiContainer.BALLOONS_TO_TAP_LABEL_DEFAULT_TEXT)

    ///
    /// The SKLabelNode that shows the current balloon tap threshold. This value is taken from the Math Master.
    ///
    private var _balloonsToTapValue: SKLabelNode = SKLabelNode(text: SKTopUiContainer.BALLOONS_TO_TAP_VALUE_DEFAULT_TEXT)

    ///
    /// The SKLabelNode that shows the text "Popped".
    ///
    private var _balloonsTappedLabel: SKLabelNode = SKLabelNode(text: SKTopUiContainer.BALLOONS_TAPPED_LABEL_DEFAULT_TEXT)

    ///
    /// The SKLabelNode that shows the current number of tapped balloons. This value is taken from the Math Master.
    ///
    private var _balloonsTappedValue: SKLabelNode = SKLabelNode(text: SKTopUiContainer.BALLOONS_TAPPED_VALUE_DEFAULT_TEXT)

    ///
    /// The width of the frame, obtained from the initializer.
    ///
    private var _sceneFrameWidth: CGFloat = 0.0

    ///
    /// The height of the frame, obtained from the initializer.
    ///
    private var _sceneFrameHeight: CGFloat = 0.0

    ///
    /// This is required but never used
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    ///
    /// This is the preferred initializer to use. The caller should provide the width and the height of the frame so that proper measurements can take place.
    ///
    init(sceneFrameWidth sfw: CGFloat, sceneFrameHeight sfh: CGFloat) {
        super.init()
        self._sceneFrameWidth = sfw
        self._sceneFrameHeight = sfh
        let myHeight: CGFloat = self._sceneFrameHeight * SKTopUiContainer.CONTAINER_HEIGHT_SCALAR

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
        self.path = mutRect
        self.position = CGPoint(x: -(self._sceneFrameWidth / 2.0), y: (self._sceneFrameHeight / 2.0) - myHeight)
        self.lineWidth = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH

        // Create the three stubs
        // Divide the width of the container by 3, use this value as the
        // width for the slabs. Also use it for placement guidance in
        // the container along the x axis
        let slabDivider: CGFloat = self.frame.width / 3.0

        self.createSlabA(slabDivider: slabDivider, myHeight: myHeight)
        self.createSlabB(slabDivider: slabDivider, myHeight: myHeight)
        self.createSlabC(slabDivider: slabDivider, myHeight: myHeight)

        self.populateSlabA(myHeight: myHeight)
        self.populateSlabB(myHeight: myHeight)
        self.populateSlabC(myHeight: myHeight)
    }

    ///
    /// Used to maintain the integrity of the Math Master display data at runtime.
    ///
    public func updateUiValues(mathMasterRef mmr: MathMaster) {
        self._levelValue.text = String(mmr.currentLevel)
        self._balloonsToTapValue.text = String(mmr.numBalloonsToPop)
        self._balloonsTappedValue.text = String(mmr.numBalloonsTapped)
    }

    ///
    /// Create the A Slab and add it to the root container.
    ///
    private func createSlabA(slabDivider sd: CGFloat, myHeight mh: CGFloat) {
        let sarect: CGMutablePath = CGMutablePath()
        sarect.addRect(CGRect(x: 0.0, y: 0.0, width: sd, height: mh))
        self._slabA.path = sarect
        self._slabA.lineWidth = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabA.strokeColor = .red
        self.addChild(self._slabA)
        self._slabA.position = CGPoint.zero
    }

    ///
    /// Create the B Slab and add it to the root container.
    ///
    private func createSlabB(slabDivider sd: CGFloat, myHeight mh: CGFloat) {
        let sbrect: CGMutablePath = CGMutablePath()
        sbrect.addRect(CGRect(x: 0.0, y: 0.0, width: sd, height: mh))
        self._slabB.path = sbrect
        self._slabB.lineWidth = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabB.strokeColor = .green
        self.addChild(self._slabB)
        self._slabB.position = CGPoint(x: sd, y: 0.0)
    }

    ///
    /// Create the C Slab and add it to the root container.
    ///
    private func createSlabC(slabDivider sd: CGFloat, myHeight mh: CGFloat) {
        let screct: CGMutablePath = CGMutablePath()
        screct.addRect(CGRect(x: 0.0, y: 0.0, width: sd, height: mh))
        self._slabC.path = screct
        self._slabC.lineWidth = SKTopUiContainer.RECT_FRAME_DEBUG_LINE_WIDTH
        self._slabC.strokeColor = .blue
        self.addChild(self._slabC)
        self._slabC.position = CGPoint(x: sd * 2.0, y: 0.0)
    }

    ///
    /// Populate the A Slab with its contents.
    ///
    private func populateSlabA(myHeight mh: CGFloat) {
        self._slabA.addChild(self._levelLabel)
        self._slabA.addChild(self._levelValue)
        self._levelLabel.fontColor = .yellow
        self._levelValue.fontSize = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slaXHalved: CGFloat = self._slabA.frame.width / 2.0
        self._levelLabel.position = CGPoint(x: slaXHalved, y: (mh - self._levelLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._levelValue.position = CGPoint(x: slaXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)
    }

    ///
    /// Populate the B Slab with its contents.
    ///
    private func populateSlabB(myHeight mh: CGFloat) {
        self._slabB.addChild(self._balloonsToTapLabel)
        self._slabB.addChild(self._balloonsToTapValue)
        self._balloonsToTapLabel.fontColor = .yellow
        self._balloonsToTapValue.fontSize = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slbXHalved: CGFloat = self._slabB.frame.width / 2.0
        self._balloonsToTapLabel.position = CGPoint(x: slbXHalved, y: (mh - self._balloonsToTapLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._balloonsToTapValue.position = CGPoint(x: slbXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)
    }

    ///
    /// Populate the C Slab with its contents.
    ///
    private func populateSlabC(myHeight mh: CGFloat) {
        self._slabC.addChild(self._balloonsTappedLabel)
        self._slabC.addChild(self._balloonsTappedValue)
        self._balloonsTappedLabel.fontColor = .yellow
        self._balloonsTappedValue.fontSize = SKTopUiContainer.VALUE_LABEL_FONT_SIZE
        let slcXHalved: CGFloat = self._slabC.frame.width / 2.0
        self._balloonsTappedLabel.position = CGPoint(x: slcXHalved, y: (mh - self._balloonsTappedLabel.frame.height) - SKTopUiContainer.HORIZONTAL_PADDING)
        self._balloonsTappedValue.position = CGPoint(x: slcXHalved, y: SKTopUiContainer.HORIZONTAL_PADDING)
    }
}
