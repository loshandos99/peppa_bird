import SpriteKit

class StartScene: BaseScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let titleLabel = SKLabelNode()
        titleLabel.text = "Flappy Bird"
        titleLabel.fontSize = 44
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        titleLabel.fontColor = SKColor.black
        addChild(titleLabel)

        let startLabel = SKLabelNode()
        startLabel.text = "Tap to Start"
        startLabel.fontSize = 24
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        titleLabel.fontColor = SKColor.black
        addChild(startLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: transition)
    }
}
