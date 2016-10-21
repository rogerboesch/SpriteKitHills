//
//  HillNode.swift
//  Created by Roger Boesch on 20/10/16.
//  Based on Ray Wenderlich article:
//  http://www.raywenderlich.com/32954/how-to-create-a-game-like-tiny-wings-with-cocos2d-2-x-part-1
//

import UIKit
import SpriteKit

func random(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

class HillNode {
    private static let kMaxHillKeyPoints = 1000
    private static let kPaddingTop: CGFloat = 20;
    private static let kPaddingBottom: CGFloat = 20
    private static let kMinDX: Int = 160
    private static let kMinDY: Int = 60
    private static let kRangeDX: Int = 80
    private static let kRangeDY: Int = 40
    private static let kHillSegmentWidth: CGFloat = 10
    
    private var _points = Array<CGPoint>()
    private var _node: SKShapeNode?
    private var _lineNode: SKShapeNode?

    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    var node: SKShapeNode {
        get {
            if _node == nil {
                generateCurvyNode()
            }
            
            return _node!
        }
    }

    // -------------------------------------------------------------------------

    var lineNode: SKShapeNode {
        get {
            if _lineNode == nil {
                generateLineNode()
            }
            
            return _lineNode!
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Helper functions

    private func generatePoints() {
        let winSize: CGSize = UIScreen.main.bounds.size
        
        var x: CGFloat = CGFloat(-HillNode.kMinDX)
        var y: CGFloat = winSize.height/2

        var dy: CGFloat = 0
        var ny: CGFloat = 0
        var sign: CGFloat = 1; // +1 - going up, -1 - going  down

        for i in 0...HillNode.kMaxHillKeyPoints-1 {
            _points.append(CGPoint(x:x, y:y))

            if i == 0 {
                x = 0
                y = winSize.height / 2
            }
            else {
                x += CGFloat(random(min: 0, max: HillNode.kRangeDX) + HillNode.kMinDX)
                
                while(true) {
                    dy = CGFloat(random(min: 0, max: HillNode.kRangeDY) + HillNode.kMinDY)
                    ny = y + dy * sign
                    
                    if ny < winSize.height-HillNode.kPaddingTop && ny > HillNode.kPaddingBottom {
                        break
                    }
                }
                
                y = ny
            }

            sign *= -1
        }
    }

    // -------------------------------------------------------------------------

    private func generateLineNode() {
        let path = CGMutablePath()

        path.move(to: CGPoint(x: _points[0].x, y: 80))

        for i in 0...HillNode.kMaxHillKeyPoints-1 {
            path.addLine(to: _points[i])
        }
        path.addLine(to: CGPoint(x: _points[HillNode.kMaxHillKeyPoints-1].x, y: 80))
        
        _lineNode = SKShapeNode()
        _lineNode!.path = path
        _lineNode!.strokeColor = UIColor.red
        _lineNode!.lineWidth = 1
    }

    // -------------------------------------------------------------------------

    private func generateCurvyNode() {
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: _points[0].x, y: 80))

        for i in 1...HillNode.kMaxHillKeyPoints-1 {
            let p0 = _points[i-1]
            let p1 = _points[i]
            let hSegments = floorf(Float(p1.x-p0.x)/Float(HillNode.kHillSegmentWidth))

            let dx = Float(p1.x - p0.x) / hSegments
            let da = Float(M_PI) / hSegments
            let ymid = (p0.y + p1.y) / 2
            let ampl = (p0.y - p1.y) / 2
            
            var pt0 = CGPoint.zero
            var pt1 = CGPoint.zero
            pt0 = p0
            
            for j in 0...Int(hSegments+1) {
                pt1.x = p0.x + CGFloat(Float(j) * dx)
                pt1.y = ymid + ampl * CGFloat(cosf(da * Float(j)))
                
                path.addLine(to: pt0)
                path.addLine(to: pt1)
                
                pt0 = pt1
            }
        }
        
        _node = SKShapeNode()
        _node!.path = path
        _node!.strokeColor = UIColor.white
        _node!.lineWidth = 1
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation

    init() {
        generatePoints()
    }

    // -------------------------------------------------------------------------
}
