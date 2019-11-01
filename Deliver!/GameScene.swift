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
    
    //var drone : SKNode
    let rect = SKShapeNode(rectOf: CGSize(width: 100, height: 50))
    static let GRAVITY = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150) // pixel ratio of 150 pixels = 1 meter
    var mass = CGFloat(10)
    var force: CGVector!
    let motion = CMMotionManager()
    var t = 0.0
    var sample = true
    var count = 0
    let cameraNode = SKCameraNode()
        
    override func didMove(to view: SKView) {
        print(self.size)
        force = CGVector(dx: 0, dy: GameScene.GRAVITY*GameScene.PIXELRATIO*mass/2)
        rect.fillColor = .red
        rect.position = CGPoint(x: 0, y: 0)
        rect.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 50))
        rect.physicsBody?.mass = mass

        addChild(rect)
        startDeviceMotion()
    }
    
    func applyForce() {
        let r = rect.zRotation
        let pos = rect.position
        let pL = CGPoint(x: pos.x-25*cos(r), y: pos.y-25*sin(r))
        let pR = CGPoint(x: pos.x+25*cos(r), y: pos.y+25*sin(r))
        /*print("pos: \(pos)")
        print("pL: \(pL)")
        print("pR: \(pR)")*/
        let vL = CGVector(dx: -force.dy*sin(r), dy: force.dy*cos(r))
        let vR = CGVector(dx: -force.dy*sin(r), dy: force.dy*cos(r))
        rect.physicsBody?.applyForce(vL, at: pL)
        rect.physicsBody?.applyForce(vR, at: pR)
        }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates()
            //self.motion.startAccelerometerUpdates()
        }
    }
    
    func cameraSetup() {
        self.camera = cameraNode
        let range = SKRange(lowerLimit: 0, upperLimit: self.frame.maxY)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //force = CGVector(dx: 0, dy: force.dy+1)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if sample {
            t = currentTime
            sample = false
        }
        let delta = currentTime-t
        applyForce()
        count += 1
        /*if let data = self.motion.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            print("X acceleration: \(x)")
            print("Y acceleration: \(y)")
            print("Z acceleration: \(z)")
        }*/
        if let data = self.motion.deviceMotion {
            let x = data.attitude.pitch
            let y = data.attitude.roll
            let z = data.attitude.yaw
            let r = data.rotationRate
            /*if count == 60 {
                print(delta)
                print("X: \(x)")
                print("Y: \(y)")
                print("Z: \(z)")
                print("x: \(r.x)")
                print("y: \(r.y)")
                print("z: \(r.z)")
                count = 0
            }*/
            //print(z*180/Double.pi)
            let tmp = (z*180/Double.pi).rounded(.towardZero)
            //print(tmp)
            rect.zRotation = CGFloat(tmp*Double.pi/180)
        }
    }
}
