import SpriteKit

class GameOverScene: BaseScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 44
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.fontColor = SKColor.black
        addChild(gameOverLabel)

        let tryAgainLabel = SKLabelNode()
        tryAgainLabel.text = "Tap to Return to Start"
        tryAgainLabel.fontSize = 24
        tryAgainLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        gameOverLabel.fontColor = SKColor.black
        addChild(tryAgainLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let startScene = StartScene(size: self.size)
        self.view?.presentScene(startScene, transition: transition)
    }
}
