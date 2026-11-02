import AVFoundation
import GameplayKit
import SpriteKit

// MARK: - CLASS:

protocol GameSceneDelegate: AnyObject {
    func gameDidEnd(withDistance distance: Int)
    func gameDidFinish(withDistance distance: Int)
}

final class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - PRIVATE PROPERTIES:

    private let mainShipNodeSettings: UInt32 = 1
    private let asterotdNodeSettings: UInt32 = 1 << 1
    private var mainShipNode: SKSpriteNode!
    private var mainShipLayerNode: SKNode!
    private var scoreLabelNode: SKLabelNode!
    private var levelLabelNode: SKLabelNode!
    private var backgroundNode: SKSpriteNode!
    private var asteroydNode: SKNode!
    private var starNode: SKNode!
    private var statusPaused: Bool = false
    private let vibrationOn = Vibration()
    private var finishLabelNode = SKLabelNode()
    private let gameVC = GameViewController()
    weak var gameDelegate: GameSceneDelegate?
    private let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
    private let finishSoundAction = SKAction.playSoundFileNamed("finishSound", waitForCompletion: true)
    var scoreValue = 0
    
    // MARK: - LIFECYCLE:
    
    override func didMove(to view: SKView) {
        setBackground()
        setMainSpaceShipNode()
        setAsteroydNodeLayer()
        setLevelLabelNode()
        setScoreLabelNode()
    }
    
    // MARK: SET GRAVITY WORLD:
    
    private func setWorldGravity() {
        if scoreValue > 0 && scoreValue <= 20 {
            physicsWorld.speed = 1.1
            levelLabelNode.text = "Level: 1"
        } else if scoreValue > 20 && scoreValue <= 40 {
            physicsWorld.speed = 1.2
            levelLabelNode.text = "Level: 2"
        } else if scoreValue > 40 && scoreValue <= 60 {
            physicsWorld.speed = 1.3
            levelLabelNode.text = "Level: 3"
        } else if scoreValue > 60 && scoreValue <= 80 {
            physicsWorld.speed = 1.4
            levelLabelNode.text = "Level: 4"
        } else if scoreValue > 80 && scoreValue <= 100 {
            physicsWorld.speed = 1.5
            levelLabelNode.text = "Level: 5"
        } else if scoreValue > 100 && scoreValue <= 120 {
            physicsWorld.speed = 1.6
            levelLabelNode.text = "Level: 6"
        } else if scoreValue > 120 && scoreValue <= 140 {
            physicsWorld.speed = 1.7
            levelLabelNode.text = "Level: 7"
        } else if scoreValue > 140 && scoreValue <= 160 {
            physicsWorld.speed = 1.8
            levelLabelNode.text = "Level: 8"
        } else if scoreValue > 160 && scoreValue <= 180 {
            physicsWorld.speed = 1.8
            levelLabelNode.text = "Level: 8"
        } else if scoreValue > 180 && scoreValue <= 200 {
            physicsWorld.speed = 1.9
            levelLabelNode.text = "Level: 9"
        } else if scoreValue > 200 && scoreValue <= 300 {
            physicsWorld.speed = 2
            levelLabelNode.text = "Level: 10"
        }
    }
    
    // MARK: PLAY SOUNDS FOR NEW LEVELS:
    
    private func playLevelSounds() {
        if scoreValue == 0 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 20 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 40 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 60 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 80 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 100 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 120 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 140 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 160 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 180 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 200 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
        } else if scoreValue == 300 {
            let hitSoundAction = SKAction.playSoundFileNamed("newLevel", waitForCompletion: true)
            run(hitSoundAction)
            let finishSoundAction = SKAction.playSoundFileNamed("finishSound", waitForCompletion: true)
            run(finishSoundAction)
        }
    }
    
    // MARK: FINISH GAME:
    
    private func finishGame() {
        if scoreValue == 300 {
            finishTheGame()
            finishLabelNode.position = CGPoint(x: frame.size.width / scoreLabelNode.frame.size.width, y: 100)
            finishLabelNode = SKLabelNode(text: "YOU WIN!\n Game is finished!\n\nGalactriX\nMalyshew Andrew\n2024")
            addChild(finishLabelNode)
            finishLabelNode.numberOfLines = 0
            finishLabelNode.horizontalAlignmentMode = .center
            finishLabelNode.zPosition = 4
            levelLabelNode.removeFromParent()
            scoreLabelNode.removeFromParent()
            asteroydNode.removeFromParent()
        }
    }
    
    //MARK: SETUP BACKGROUND:

    private func setBackground() {
        scene?.size = UIScreen.main.bounds.size
        
        backgroundNode = SKSpriteNode(imageNamed: "spaceBackground")
        backgroundNode.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addChild(backgroundNode)
        
        let effectStars = SKEmitterNode(fileNamed: "Stars.sks")
        effectStars?.zPosition = 5
        effectStars?.position = CGPoint(x: frame.midX, y: frame.height / 2)
        effectStars?.particlePositionRange.dx = frame.width
        effectStars?.advanceSimulationTime(10)
        
        starNode = SKNode()
        starNode.zPosition = 1
        addChild(starNode)
        guard let effectStars = effectStars else { return }
        starNode.addChild(effectStars)
        
        backgroundNode.zPosition = 0
    }

    // MARK: SET SPACE SHIP:
    
    private func setMainSpaceShipNode() {
        mainShipNode = SKSpriteNode(imageNamed: "spaceShip")
        mainShipNode.xScale = 0.08
        mainShipNode.yScale = 0.08
        mainShipNode.physicsBody?.categoryBitMask = mainShipNodeSettings
        mainShipNode.physicsBody?.contactTestBitMask = asterotdNodeSettings
        mainShipNode.physicsBody?.collisionBitMask = asterotdNodeSettings
        mainShipNode.physicsBody = SKPhysicsBody(texture: mainShipNode.texture!, size: mainShipNode.size)
        mainShipNode.physicsBody?.isDynamic = false
        
        mainShipLayerNode = SKNode()
        mainShipLayerNode.addChild(mainShipNode)
        mainShipLayerNode.zPosition = 3
        mainShipNode.zPosition = 1
        mainShipLayerNode.position = CGPoint(x: frame.midX, y: frame.height / 50)
        addChild(mainShipLayerNode)
        
        let effectFire = SKEmitterNode(fileNamed: "Fire.sks")
        effectFire?.zPosition = 0
        effectFire?.position.y = -40
        effectFire?.targetNode = self
        guard let effectFire = effectFire else { return }
        mainShipLayerNode.addChild(effectFire)
    }
    
    //MARK: SET ASTEROYD NODE LAYER:

    private func setAsteroydNodeLayer() {
        asteroydNode = SKNode()
        asteroydNode.zPosition = 2
        addChild(asteroydNode)

        let newAsteroyd = SKAction.run {
            let asteroyd = self.createAsteroid()
            self.asteroydNode.addChild(asteroyd)
            asteroyd.zPosition = 2
        }
        
        let countsAsteroydsOneSecond: Double = 2
        let asteroydDelay = SKAction.wait(forDuration: 1.0 / countsAsteroydsOneSecond, withRange: 0.5)
        let asteroydSequence = SKAction.sequence([newAsteroyd, asteroydDelay])
        let asteroydRun = SKAction.repeatForever(asteroydSequence)
        
        asteroydNode.run(asteroydRun)
    }
    
    // MARK: SET SCORE LABEL NODE:

    private func setScoreLabelNode() {
        scoreLabelNode = SKLabelNode(text: "Score: \(scoreValue)")
        scoreLabelNode.position = CGPoint(x: frame.size.width / scoreLabelNode.frame.size.width, y: 300)
        addChild(scoreLabelNode)
        scoreLabelNode.zPosition = 3
    }
    
    // MARK: SET LEVEL LABEL NODE:
    
    private func setLevelLabelNode() {
        levelLabelNode = SKLabelNode(text: "Level: 1")
        levelLabelNode.position = CGPoint(x: frame.size.width / levelLabelNode.frame.size.width, y: 270)
        addChild(levelLabelNode)
        levelLabelNode.zPosition = 4
    }
    
    // MARK: TOUCH BEGAN:

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !statusPaused {
            vibrationOn.vibrationHard()
            if let touchOnScreen = touches.first {
                let tapLocation = touchOnScreen.location(in: self)
                let moveDistance = calcDistance(a: mainShipNode.position, b: tapLocation)
                let flyMoveSpeed: CGFloat = 499
                let flyTime = distanceTime(valueDistance: moveDistance, valueSpeed: flyMoveSpeed)
                let actionMove = SKAction.move(to: tapLocation, duration: flyTime)
                actionMove.timingMode = SKActionTimingMode.easeInEaseOut
                mainShipLayerNode.run(actionMove)
                let bgMoveAction = SKAction.move(to: CGPoint(x: -tapLocation.x / 75, y: -tapLocation.y / 75), duration: flyTime)
                backgroundNode.run(bgMoveAction)
            }
        }
    }
    
    // MARK: - PAUSE GAME:

    func pauseTheGame() {
        statusPaused = true
        asteroydNode.isPaused = true
        physicsWorld.speed = 0
        starNode.isPaused = true
    }
    
    // MARK: - UNPAUSE GAME:
    func unpauseTheGame() {
        statusPaused = false
        asteroydNode.isPaused = false
        physicsWorld.speed = 1
        starNode.isPaused = false
    }
    
    // MARK: - FINISH GAME:
    func finishTheGame() {
        statusPaused = true
        asteroydNode.isPaused = true
        physicsWorld.speed = 0
        starNode.isPaused = true
    }
    
    // MARK: - RESET GAME:
    
    func resetTheGame() {
        scoreValue = 0
        scoreLabelNode.text = "Score: \(scoreValue)"
        statusPaused = false
        asteroydNode.isPaused = false
        physicsWorld.speed = 1
    }
    
    // MARK: - CALC DISTANCE
    
    func calcDistance(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))
    }
    
    // MARK: - DISTANCE TIME:
    
    func distanceTime(valueDistance: CGFloat, valueSpeed: CGFloat) -> TimeInterval {
        let valueTime = valueDistance / valueSpeed
        return TimeInterval(valueTime)
    }
    
    // MARK: - CREATE ASTEROYD:
    
    func createAsteroid() -> SKSpriteNode {
        let mainAsteroyd = SKSpriteNode(imageNamed: "asteroid")
        let sizeRandom = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 7)) / 21
        mainAsteroyd.yScale = sizeRandom
        mainAsteroyd.xScale = sizeRandom
        mainAsteroyd.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 17))
        mainAsteroyd.position.y = frame.size.height + mainAsteroyd.size.height
        mainAsteroyd.physicsBody = SKPhysicsBody(texture: mainAsteroyd.texture!, size: mainAsteroyd.size)
        mainAsteroyd.name = "asteroid"
        mainAsteroyd.physicsBody?.categoryBitMask = asterotdNodeSettings
        mainAsteroyd.physicsBody?.collisionBitMask = mainShipNodeSettings | asterotdNodeSettings
        mainAsteroyd.physicsBody?.contactTestBitMask = mainShipNodeSettings
        let asteroidSpeed: CGFloat = 99
        mainAsteroyd.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3
        mainAsteroyd.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeed
        
        // SET VALUE FOR TRAECTORY ASTEROYD:
        
        physicsWorld.contactDelegate = self
        let randomValues = Double.random(in: -0.5...0.5)
        physicsWorld.gravity = CGVector(dx: randomValues, dy: -0.7)
        
        return mainAsteroyd
    }
    
    // MARK: - DID SIMULATE PHYSICS:
    
    override func didSimulatePhysics() {
        asteroydNode.enumerateChildNodes(withName: "asteroid") { asteroyd, _ in
            let hightScreenView = UIScreen.main.bounds.height
            if asteroyd.position.y < -hightScreenView {
                asteroyd.removeFromParent()
                self.scoreValue = self.scoreValue + 1
                self.scoreLabelNode.text = "Score: \(self.scoreValue)"
                self.setWorldGravity()
                self.playLevelSounds()
                self.finishGame()
            }
        }
    }
    
    // MARK: - DID BEGIN:
    
    func didBegin(_ contact: SKPhysicsContact) {
        VibrationManager.instance.vibrationError()
        UserDefaults.standard.setValue("backgroundMusic", forKey: "music")
        if contact.bodyA.categoryBitMask == mainShipNodeSettings && contact.bodyB.categoryBitMask == asterotdNodeSettings || contact.bodyB.categoryBitMask == mainShipNodeSettings && contact.bodyA.categoryBitMask == asterotdNodeSettings {
            showGameOverViewController(withScore: scoreValue)
            scoreValue = 0
            scoreLabelNode.text = "Score: \(scoreValue)"
        }
        let hitSoundAction = SKAction.playSoundFileNamed("hitSound", waitForCompletion: true)
        run(hitSoundAction)
        showGameOverViewController(withScore: scoreValue )
        pauseTheGame()
    }
}

// MARK: - EXTENSION:

extension GameScene {
    func showGameOverViewController(withScore score: Int) {
        print("Game over")
        gameDelegate?.gameDidEnd(withDistance: score)
    }
    
    func showFinishViewController(withDistance distance: Int) {
        print("Finish game")
        gameDelegate?.gameDidFinish(withDistance: 300)
    }
}
