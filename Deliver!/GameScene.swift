//
//  GameScene.swift
//  Deliver!
//
//  Created by Adam Zhao on 9/2/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let test = Drone()
    static let GRAVITY = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150)
    // pixel ratio of 150 pixels = 1 meter
    let motion = CMMotionManager()
    var startTime = 0.0
    var t = 0.0
    var dt: CGFloat = 0.0
    var start = true
    var previousTime: TimeInterval = 0.0
    var dx: CGFloat = 0.0
    let cameraNode = SKCameraNode()
        
    override func didMove(to view: SKView) {
        startDeviceMotion()
        test.addAll(self)
        cameraSetup()
        
        print(self.size.width)
        print(self.frame.maxX)
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates()
        }
    }
    
    func cameraSetup() {
        self.camera = cameraNode
        let range = SKRange(lowerLimit: 0, upperLimit: self.frame.maxY)
        let constraint1 = SKConstraint.distance(range, to: test.body)
        let constraint2 = SKConstraint.positionY(SKRange(lowerLimit: -1000, upperLimit: 1000))
        let constraint3 = SKConstraint.positionX(SKRange(lowerLimit: -2500, upperLimit: 2500))
        cameraNode.constraints = [constraint1, constraint2, constraint3]
        addChild(cameraNode)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if previousTime != 0.0 {
            for touch in touches {
                //print(touch.location(in: cameraNode))
                if (touch.location(in: cameraNode).x / self.frame.maxX) > 0.5 {
                    dt = CGFloat(touch.timestamp - previousTime)
                    dx = touch.location(in: cameraNode).y - touch.previousLocation(in: cameraNode).y
                    //print("touchesMoved", dt, dx, "\n")
                    print(dx/dt/5)
                    // divide by 5 to make it easier to control
                    test.force.dy = test.force.dy + dx/dt/5
                }
                
                if (touch.location(in: cameraNode).x / self.frame.minX) > 0.5 {
                    
                }
                previousTime = touch.timestamp
            }
        } else {
            previousTime = touches.first!.timestamp
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTime = 0.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        t = currentTime
        if start {
            startTime = currentTime
            start = false
        }
        
        if let data = self.motion.deviceMotion {
            let z = data.attitude.yaw
            let tmp = (z*180/Double.pi).rounded(.towardZero)
            let rotation = CGFloat(tmp*Double.pi/180)
            test.body.zRotation = rotation
            test.applyForce()
            //print(test.force.dy)
        }
    }
}
