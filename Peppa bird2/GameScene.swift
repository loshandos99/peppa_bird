import SpriteKit

class BaseScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size  // Make sure the background covers the entire screen
        background.zPosition = -20  // Ensure the background is behind other nodes
        addChild(background)
    }

    
}


class GameScene: BaseScene, SKPhysicsContactDelegate {
    var bird: SKSpriteNode!
    var pipePair: SKNode!
    var scoreLabel: SKLabelNode!
    var score = 0

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.gravity = CGVector(dx: 0, dy: -10)
        physicsWorld.contactDelegate = self
        

        bird = SKSpriteNode(imageNamed: "peppa_bird")
        bird.setScale(0.2)
        bird.position = CGPoint(x: frame.midX - frame.midX/3, y: frame.midY)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = true
        bird.physicsBody?.categoryBitMask = 1
        bird.physicsBody?.collisionBitMask = 2
        bird.physicsBody?.contactTestBitMask = 2

        addChild(bird)
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = " \(score)"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY+frame.midY*3/4)
        addChild(scoreLabel)

        
        let spawnAction = SKAction.run(spawnPipes)
        let initialWaitDuration: TimeInterval = 2.0
        let waitAction = SKAction.wait(forDuration: initialWaitDuration)
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])

        run(SKAction.repeatForever(spawnSequence))

        // If you want to gradually increase the spawn rate, update the wait duration periodically:
        let decrementInterval = TimeInterval(0.1)
        let minWaitDuration = TimeInterval(1.0)

        let adjustSpawnRate = SKAction.run {
            let newWaitDuration = max(initialWaitDuration - decrementInterval * Double(self.score), minWaitDuration)
            waitAction.duration = newWaitDuration
        }

        // Run adjustSpawnRate at regular intervals:
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 5.0), // Adjust this duration as needed
                adjustSpawnRate
            ])
        ))

    }
    
    
    
    func spawnPipes() {
        let gapHeight =  1.25*bird.size.height
        
        let pipeTexture = SKTexture(imageNamed: "Pipe2")
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: frame.width + pipeTexture.size().width, y: 0)

        let height = UInt32(frame.height / 4)
        let y = Double(arc4random_uniform(height) + height)

        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.setScale(0.15)
        pipe1.position = CGPoint(x: 0, y: y + Double(pipe1.size.height) + 0.25*Double(gapHeight))
        pipe1.zRotation = 3.14

        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
        pipe1.physicsBody?.isDynamic = false
        pipe1.physicsBody?.categoryBitMask = 2
        pipePair.addChild(pipe1)
        
        let pipe2 = SKSpriteNode(texture: pipeTexture)
        pipe2.setScale(0.15)
        pipe2.position = CGPoint(x: 0, y: y - Double(pipe1.size.height) - 0.25*Double(gapHeight))

        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2.size)
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.categoryBitMask = 2
        pipePair.addChild(pipe2)

        let contactNode = SKNode()
        contactNode.position = CGPoint(x: pipe1.size.width + bird.size.width / 2, y: frame.midY)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: frame.height))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = 4
        contactNode.physicsBody?.contactTestBitMask = 1
        pipePair.addChild(contactNode)

        // Calculate the move duration based on the width of the screen and the desired speed
        let pipeMoveSpeed: CGFloat = 200.0  // Pixels per second, adjust this value as needed
        let distanceToMove = frame.width + pipeTexture.size().width * 2
        let moveDuration = distanceToMove / pipeMoveSpeed

        // Move the pipes and remove them when they are completely off-screen
        let moveAction = SKAction.moveBy(x: -distanceToMove, y: 0, duration: TimeInterval(moveDuration))
        let removeAction = SKAction.removeFromParent()
        pipePair.run(SKAction.sequence([moveAction, removeAction]))
        pipePair.zPosition = -1
        addChild(pipePair)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            score += 1
            scoreLabel.text = "\(score)"
            scoreLabel.zPosition = 1
        } else {
            gameOver()
        }
    }

    func gameOver() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .aspectFill
        self.view?.presentScene(gameOverScene, transition: transition)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 50)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 45))
    }

    override func update(_ currentTime: TimeInterval) {
        // Check if the bird goes off screen
        if  bird.position.y < 0 {
            gameOver()
        }
        
        // Rotate the bird based on its vertical velocity
            if let birdPhysicsBody = bird.physicsBody {
                // Calculate the angle using atan2
                let angle = atan2(birdPhysicsBody.velocity.dy, 300.0)
                bird.zRotation = angle - 1.0
            }

    }
}
