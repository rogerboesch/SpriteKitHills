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
    private static let kHillSegmentWidth: CGFloat = 10
    
    private var _minHillKeyPoints: Int = 100
    
    private var _paddingTop: CGFloat = 20
    private var _paddingBottom: CGFloat = 20
    private var _minDX: Int = 160
    private var _minDY: Int = 60
    private var _rangeDX: Int = 80
    private var _rangeDY: Int = 40
    
    private var _points = Array<CGPoint>()
    private var _node: SKShapeNode?
    private var _image: UIImage?
    private var _lineColor = UIColor.clear
    private var _lineWidth: CGFloat = 1.0
    
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
    
    var textureImage: UIImage? {
        get {
            return _image
        }
        set(value) {
            _image = value
            
            applyTexture()
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minHillKeyPoints: Int {
        get {
            return _minHillKeyPoints
        }
        set(value) {
            if value > 2 {
                _points.removeAll()
                _minHillKeyPoints = value
            }
            else {
                // TDOO: Warning
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    var paddingTop: CGFloat {
        get {
            return _paddingTop
        }
        set(value) {
            _points.removeAll()
            _paddingTop = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var paddingBottom: CGFloat {
        get {
            return _paddingBottom
        }
        set(value) {
            _points.removeAll()
            _paddingBottom = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minDX: Int {
        get {
            return _minDX
        }
        set(value) {
            _points.removeAll()
            _minDX = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var minDY: Int {
        get {
            return _minDY
        }
        set(value) {
            _points.removeAll()
            _minDY = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rangeDX: Int {
        get {
            return _rangeDX
        }
        set(value) {
            _points.removeAll()
            _rangeDX = value
        }
    }
    
    // -------------------------------------------------------------------------
    
    var rangeDY: Int {
        get {
            return _rangeDY
        }
        set(value) {
            _points.removeAll()
            _rangeDY = value
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Helper functions
    
    private func applyTexture() {
        if _node == nil {
            return
        }
        
        if _image == nil {
            _node?.fillTexture = nil
            return
        }
        
        // Just for demo purpose, make in real game more accurate
        let targetSize = CGSize(width: 10, height: 200)
        
        UIGraphicsBeginImageContext(targetSize)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(_image!.cgImage!, in: CGRect(x:0, y:0, width:targetSize.width, height:targetSize.height), byTiling: true)
        let texture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        _node!.fillTexture = SKTexture(image: texture!)
    }
    
    // -------------------------------------------------------------------------
    
    private func generatePoints() {
        _points.removeAll()
        
        let winSize: CGSize = UIScreen.main.bounds.size
        
        var x: CGFloat = CGFloat(-_minDX)
        var y: CGFloat = winSize.height/2
        var dy: CGFloat = 0
        var ny: CGFloat = 0
        var sign: CGFloat = 1 // +1 - going up, -1 - going  down
        
        for i in 0..._minHillKeyPoints-1 {
            _points.append(CGPoint(x:x, y:y))
            
            if i == 0 {
                x = 0
                y = winSize.height / 2
            }
            else {
                x += CGFloat(random(min: 0, max: _rangeDX) + _minDX)
                
                while(true) {
                    dy = CGFloat(random(min: 0, max: _rangeDY) + _minDY)
                    ny = y + dy * sign
                    
                    if ny < winSize.height-_paddingTop && ny > _paddingBottom {
                        break
                    }
                }
                
                y = ny
            }
            
            sign *= -1
        }
        
        // Last point
        x += CGFloat(random(min: 0, max: _rangeDX) + _minDX)
        _points.append(CGPoint(x:x, y:CGFloat(_minDY)+_paddingBottom))
    }
    
    // -------------------------------------------------------------------------
    
    private func generateCurvyNode() {
        if _points.count == 0 {
            generatePoints()
        }
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: _points[0].x, y: 0))
        
        var lastX: CGFloat = 0
        
        for i in 1..._points.count-1 {
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
                
                lastX = pt1.x
            }
        }
        
        path.addLine(to: CGPoint(x: lastX, y: 0))
        
        _node = SKShapeNode()
        _node!.path = path
        _node!.strokeColor = _lineColor
        _node!.fillColor = UIColor.white
        _node!.lineWidth = _lineWidth
        
        _node!.physicsBody = SKPhysicsBody(edgeChainFrom: path)
        _node!.physicsBody?.isDynamic = false
        
        applyTexture()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    init() {
    }
    
    // -------------------------------------------------------------------------
}
