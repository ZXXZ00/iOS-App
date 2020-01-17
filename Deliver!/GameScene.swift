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

class GameScene: SKScene{
    
    let defaultDrone = Drone()
    static let gravity = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150)
    // pixel ratio of 150 pixels = 1 meter
    let motion = CMMotionManager()
    var isEngineStarted = false
    var start = true
    var startTime = 0.0
    var t = 0.0 // t stands for time
    var dt: CGFloat = 0.0 // dt is change in time
    var previousTime: TimeInterval = 0.0
    var dx: CGFloat = 0.0 // dx is change in x direction
    let cameraNode = SKCameraNode()
    var background: SKNode?
    var houses: [SKNode] = []
    // SKSpriteNode below are dashboard section
    let dashboard = SKSpriteNode(imageNamed: "dashboard")
    let dashboardPointer = SKSpriteNode(imageNamed: "pointer")
    let level = SKSpriteNode(imageNamed: "level")
    let line = SKSpriteNode(imageNamed: "line")
    var power = -CGFloat.pi/2 // rotation of dashboardPointer
                    
    override func didMove(to view: SKView) {
        startDeviceMotion()
        defaultDrone.addAll(self)
        
        let coeff:CGFloat = GameViewController.sizeCoefficient
        print("coeff", coeff)
        //background = childNode(withName: "background")
        //background = SKSpriteNode(imageNamed: "test")
        //background!.physicsBody = SKPhysicsBody(edgeLoopFrom: background!.frame)
        //background?.setScale(coeff)
        //background = SKSpriteNode(texture: texture1)
        //addChild(background!)
        //addChild(clouds)
        
        cameraSetup()
        
    }
    
    @objc func loadPackage() {
        
    }
    
    @objc func dropPackage() {
        
    }
    
    func changeScene(sksFilename: String, typeOfScene: String) {
        if typeOfScene == "GameScene" {
            if let scene = GameScene(fileNamed: sksFilename) {
                self.view?.presentScene(scene)
            }
        }
        if typeOfScene == "MenuScene" {
            if let scene = MenuScene(fileNamed: sksFilename) {
                self.view?.presentScene(scene)
            }
        }
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        }
        defaultDrone.startEngine()
        dashboardPointer.run(SKAction.rotate(toAngle: power, duration: 3, shortestUnitArc: true)) {
            self.isEngineStarted = true
            print(self.isEngineStarted)
        }
    }
    
    func cameraSetup() {
        print("Y", self.frame.maxY)
        print("X", self.frame.maxX)
        self.camera = cameraNode
        let range = SKRange(lowerLimit: 0, upperLimit: self.frame.maxY-50)
        // minus 50 to give more space to show drone
        let constraint1 = SKConstraint.distance(range, to: defaultDrone.body)
        cameraNode.constraints = [constraint1]
        if let limitX = background?.frame.size.width {
            let constraint2 = SKConstraint.positionX(SKRange(lowerLimit: -limitX/2+frame.maxX, upperLimit: limitX/2-frame.maxX))
            cameraNode.constraints?.append(constraint2)
        } // limit in x direction
        if let limitY = background?.frame.size.height {
            let constraint3 = SKConstraint.positionY(SKRange(lowerLimit: -limitY/2+frame.maxY, upperLimit: limitY/2-frame.maxY))
            cameraNode.constraints?.append(constraint3)
        } // limit in y direction
        
        // dashboard section
        dashboard.setScale(0.8*GameViewController.sizeCoefficient)
        dashboardPointer.setScale(0.8*GameViewController.sizeCoefficient)
        level.setScale(0.8*GameViewController.sizeCoefficient)
        line.setScale(0.8*GameViewController.sizeCoefficient)
        let center = CGPoint(x: self.frame.maxX-75, y: self.frame.maxY-60)
        dashboard.position = center
        dashboardPointer.position = center
        level.position = center
        line.position = center
        dashboard.zPosition = 1
        dashboardPointer.zPosition = 2
        level.zPosition = 2
        line.zPosition = 3
        cameraNode.addChild(dashboard)
        cameraNode.addChild(dashboardPointer)
        cameraNode.addChild(level)
        cameraNode.addChild(line)
        
        addChild(cameraNode)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if previousTime != 0.0 {
            for touch in touches {
                if (touch.location(in: cameraNode).x / self.frame.maxX) > 0.5 {
                    dt = CGFloat(touch.timestamp - previousTime)
                    // dt is change in time
                    dx = touch.location(in: cameraNode).y - touch.previousLocation(in: cameraNode).y
                    // dx is change in distance in y component
                    if dt == 0 { // sometimes dt will be 0
                        dt = 0.01 // but dt has to be larger than 0
                    }
                    // calculate touch move speed
                    if isEngineStarted {
                        let change = dx/dt/GameViewController.sensitivity
                        power = power - change*CGFloat.pi/180/defaultDrone.powerLimitCoefficient
                        if power <= 0 && power >= -CGFloat.pi {
                            defaultDrone.force.dy = defaultDrone.force.dy + change
                            dashboardPointer.zRotation = power
                        } else if power > 0 {
                            power = 0
                            defaultDrone.force.dy = defaultDrone.powerLowerLimit
                            dashboardPointer.zRotation = power
                        } else if power < -CGFloat.pi {
                            power = -CGFloat.pi
                            defaultDrone.force.dy = defaultDrone.powerUpperLimit
                            dashboardPointer.zRotation = power
                        }
                    }
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
            let x = data.attitude.pitch
            let y = data.attitude.roll
            let z = data.attitude.yaw
            let tmp = (z*180/Double.pi).rounded(.toNearestOrAwayFromZero)
            let xD = (x*180/Double.pi).rounded(.toNearestOrAwayFromZero)
            let yD = (y*180/Double.pi).rounded(.toNearestOrAwayFromZero)
            let rotation = GameViewController.orientation * CGFloat(xD*Double.pi/180)
            // there is a way to offset the rotation by minus the initial rotation when the game first lauches so that the player can play this when they lie down. but I am not going to add it right now
            //print("x:", xD, "y:", yD, "z:", tmp)
            //print(z, tmp, rotation)o
            defaultDrone.body.zRotation = rotation
            level.zRotation = rotation
            defaultDrone.applyForce()
        }
    }
}
