//
//  GameViewController.swift
//  Created by Roger Boesch on 20/10/16.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKScene(size: self.view.bounds.size)
        scene.scaleMode = .resizeFill
        
        let hills = HillNode()
        scene.addChild(hills.lineNode)
        scene.addChild(hills.node)

        let text = SKLabelNode(text: "Hills Demo")
        text.position = CGPoint(x: 100, y: 50)
        scene.addChild(text)

        let view = SKView()
        self.view = view
        view.presentScene(scene)

        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
        let action = SKAction.moveBy(x: -100, y: 0, duration: 1.0)
        hills.node.run(SKAction.repeatForever(action))
        hills.lineNode.run(SKAction.repeatForever(action))
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
