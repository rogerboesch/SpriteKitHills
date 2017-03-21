//
//  GameScene.swift
//  stickyhills
//
//  Created by Roger Boesch on 21.03.17.
//  Copyright © 2017 Roger Boesch. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            
            let node = SKShapeNode(circleOfRadius: 20.0)
            node.position = pos
            node.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
            node.physicsBody?.isDynamic = true
            self.addChild(node)
        }
    }
    
}
