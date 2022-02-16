import UIKit
import SpriteKit


class GameViewController: UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load your GameScene
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.size = self.view.frame.size
        skView.presentScene(scene)
    }
    
    override open var shouldAutorotate: Bool {
       return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .landscape
    }
    
}
