//
//  MathMaster.swift
//  Balloon Popper
//
//  Created by Gregory Frank Martin on 5/1/22.
//

import Foundation

class MathMaster {
    ///
    /// The number of times the player can retry a level without having to use a continue. If this drops to zero and the player loses a level, they must use a continue to keep playing the game at the current level. Currently, there is no way to increase this value (insofar as a powerup in the game is concerned).
    ///
    private var _lives: Int = 3
    
    ///
    /// The number of times the player can restart the game from the same level after losing all their lives. Currently, there is no way to increase this value (insofar as a powerup in the game is concerned).
    ///
    private var _continues: Int = 3
    
    ///
    /// The current score that the player has. Different kinds of balloons yield different numbers of points.
    ///
    private var _currentScore: Int = 0
    
    ///
    /// The current level of play. It starts at zero and is incremented before the play starts.
    ///
    private var _currentLevel: Int = 0
    
    ///
    /// This number represents the base number of balloons that are ever going to fly in a level.
    ///
    private var _baseNumBalloons: Float = 10.0
    
    ///
    /// The current number of balloons that will fly for this level. As mentioned above, the formula to determine this is as follows: (Base Number \* Scalar) + Base Number.
    ///
    private var _numBalloonsForLevel: Int = 0
    
    ///
    /// The current number of balloons that have been tapped in this level. This value is reset at the start of each level.
    ///
    private var _numBalloonsTapped: Int = 0
    
    ///
    /// The current number of balloons that need to be popped to consider the level a win.
    ///
    private var _numBalloonsToPop: Int = 0
    
    ///
    /// Used to determine if a balloon can be launched from the bottom of the screen.
    ///
    private var _balloonLaunchThreshold: Int = 5
    
    ///
    /// The tracker for the balloons that are launched in the level.
    ///
    private var _balloonTracker: [ModernBalloon] = []
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var lives: Int {
        get {
            return self._lives
        }
        set {
            self._lives = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var continues: Int {
        get {
            return self._continues
        }
        set {
            self._continues = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var currentScore: Int {
        get {
            return self._currentScore
        }
        set {
            self._currentScore = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var currentLevel: Int {
        get {
            return self._currentLevel
        }
        set {
            self._currentLevel = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var numBalloonsForLevel: Int {
        get {
            return self._numBalloonsForLevel
        }
        set {
            self._numBalloonsForLevel = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var numBalloonsTapped: Int {
        get {
            return self._numBalloonsTapped
        }
        set {
            self._numBalloonsTapped = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var numBalloonsToPop: Int {
        get {
            return self._numBalloonsToPop
        }
        set {
            self._numBalloonsToPop = newValue
        }
    }
    
    ///
    /// Public accessor for the private member of the same name.
    ///
    public var balloonTracker: [ModernBalloon] {
        get {
            return self._balloonTracker
        }
    }
    
    ///
    /// In this current iteration, this is a poor way of implementing difficulty while also castrating the number of possible levels (although at this stage in development, it's not the end of the world). Essentially, we have 10 levels with a literal difficulty scalar. The key is the level and the value is a two-member tuple where the first value is the difficulty scalar and the second value is threshold for level completion (a.k.a. the number of balloons that need popped to have been considered a win).
    ///
    /// The formula to determine the number of balloons per level to fly is as follows: (Base Number \* Scalar) + Base Number = Total Balloons
    ///
    static public let difficultyLookupTable: [Int : (Float, Float)] = [
        1  : (1.0, 0.5),   // Total number of balloons here is 20
        2  : (1.5, 0.6),   // Total number of balloons here is 25
        3  : (2.0, 0.7),   // Total number of balloons here is 30
        4  : (3.8, 0.75),  // Total number of balloons here is 48
        5  : (4.7, 0.8),   // Total number of balloons here is 57
        6  : (5.3, 0.8),   // Total number of balloons here is 63
        7  : (6.6, 0.82),  // Total number of balloons here is 76
        8  : (7.1, 0.85),  // Total number of balloons here is 81
        9  : (10.0, 0.85), // Total number of balloons here is 110
        10 : (30.0, 0.9)   // Total number of balloons here is 310
    ]
    
    ///
    /// Prepares a level
    ///
    public func prepareLevel () {
        // Increment the level counter
        self._currentLevel += 1
        
        // Reset the tapped balloons counter
        self._numBalloonsTapped = 0
        
        // Prepare the current number of balloons for this level
        // Use destructuring for this because the number index method looks silly
        let (dscalar, cthreshold) = MathMaster.difficultyLookupTable[self._currentLevel]!
        self._numBalloonsForLevel = Int.init((self._baseNumBalloons * dscalar) + self._baseNumBalloons)
        self._numBalloonsToPop = Int.init(Float.init(self._numBalloonsForLevel) * cthreshold)
        
        // Clear the balloon tracker
        self._balloonTracker = []
    }
    
    ///
    /// This will be called when the player has missed the total number of allowable balloons in the level.
    ///
    public func restartLevel (_ gm: GameMaster) {
        // Reset the tapped balloons counter
        self._numBalloonsTapped = 0
        
        // Prepare the current number of balloons for this level
        // Use destructuring for this because the number index method looks silly
        let (dscalar, cthreshold) = MathMaster.difficultyLookupTable[self._currentLevel]!
        self._numBalloonsForLevel = Int.init((self._baseNumBalloons * dscalar) + self._baseNumBalloons)
        self._numBalloonsToPop = Int.init(Float.init(self._numBalloonsForLevel) * cthreshold)
        
        // Clear the balloon tracker
        self._balloonTracker = []
    }
    
    ///
    /// Says if the player has popped enough balloons to win the current level or not.
    ///
    public func hasPlayerWon () -> Bool {
        return self._numBalloonsTapped >= self._numBalloonsToPop
    }
    
    ///
    /// Attempts to launch a ballon
    ///
    public func tryBalloonLaunch () -> Bool {
        let chance = Int.random(in: 0 ..< 500)
        if chance < self._balloonLaunchThreshold {
            return true
        } else {
            return false
        }
    }
}
