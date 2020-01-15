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

class GameScene: SKScene, ChangeSceneDelegate{
    
    let defaultDrone = Drone()
    static let GRAVITY = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150)
    // pixel ratio of 150 pixels = 1 meter
    let motion = CMMotionManager()
    var start = true
    var startTime = 0.0
    var t = 0.0 // t stands for time
    var dt: CGFloat = 0.0 // dt is change in time
    var previousTime: TimeInterval = 0.0
    var dx: CGFloat = 0.0 // dx is change in x direction
    let cameraNode = SKCameraNode()
    var background: SKNode?
    
    let dropButton = Button(imageName: "dropButton")
    let loadButton = Button(imageName: "loadButton")
            
    override func didMove(to view: SKView) {
        startDeviceMotion()
        defaultDrone.addAll(self)
        
        let coeff:CGFloat = GameViewController.sizeCoefficient
        print("coeff", coeff)
        background = childNode(withName: "background")
        background!.physicsBody = SKPhysicsBody(edgeLoopFrom: background!.frame)
        background?.setScale(coeff)
        let house1 = childNode(withName: "house1")
        house1?.setScale(coeff)
                
        cameraSetup()
        
        let test = Button(imageName: "start", action: #selector(GameScene.changeTest), target: self)
        
        addChild(test)
    }
    
    @objc func changeTest() {
        print("it run")
        if let scene = GameScene(fileNamed: "GameScene") {
            self.view?.presentScene(scene)
        }
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
    }
    
    func cameraSetup() {
        self.camera = cameraNode
        let range = SKRange(lowerLimit: 0, upperLimit: self.frame.maxY-50)
        // minus 50 to give more space to show drone
        let constraint1 = SKConstraint.distance(range, to: defaultDrone.body)
        cameraNode.constraints = [constraint1]
        if let limitX = background?.frame.size.width {
            let constraint2 = SKConstraint.positionX(SKRange(lowerLimit: -limitX/2+frame.maxX, upperLimit: limitX/2-frame.maxX))
            cameraNode.constraints?.append(constraint2)
        }
        if let limitY = background?.frame.size.height {
            let constraint3 = SKConstraint.positionY(SKRange(lowerLimit: -limitY/2+frame.maxY, upperLimit: limitY/2-frame.maxY))
            cameraNode.constraints?.append(constraint3)
        }
        let inGameUI = SKSpriteNode(imageNamed: "inGameUI")
        inGameUI.setScale(0.6*GameViewController.sizeCoefficient)
        cameraNode.addChild(inGameUI)
        addChild(cameraNode)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchedNodes = nodes(at: touch.location(in: self))
            //print(touchedNodes)
        }
        //print("test")
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
                    print("dx", dx, "dt", dt)
                    // calculate touch move speed
                    defaultDrone.force.dy = defaultDrone.force.dy + dx/dt/GameViewController.sensitivity
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
            let rotation = -CGFloat(xD*Double.pi/180)
            //print("x:", xD, "y:", yD, "z:", tmp)
            //print(z, tmp, rotation)o
            defaultDrone.body.zRotation = rotation
            defaultDrone.applyForce()
        }
    }
}
