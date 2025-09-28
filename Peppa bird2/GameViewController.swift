import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        playBackgroundMusic()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'StartScene'
            let scene = StartScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true

            

        }
    }

    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
