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
import AVFoundation
import AVKit

class GameScene: SKScene, DroneDelegate {
    
    let drone = Drone()
    static let gravity = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150)
    // pixel ratio of 150 pixels = 1 meter
    let motion = CMMotionManager()
    var isTakingUserInput = true
    var isEngineStarted = false
    var start = true
    var startTime = 0.0
    var t = 0.0 // t stands for time
    var dt: CGFloat = 0.0 // dt is change in time
    var previousTime: TimeInterval = 0.0
    var dx: CGFloat = 0.0 // dx is change in x direction
    let cameraNode = SKCameraNode()
    var background: SKNode?
    var warehouse: SKNode?
    var houses: [SKNode] = []
    // SKSpriteNode below are dashboard section
    let dashboard = SKSpriteNode(imageNamed: "dashboard")
    let dashboardPointer = SKSpriteNode(imageNamed: "pointer")
    let level = SKSpriteNode(imageNamed: "level")
    let line = SKSpriteNode(imageNamed: "line")
    var power = -CGFloat.pi/2 // rotation of dashboardPointer
    // Below are buttons in the game
    let drop = Button(imageNamed: "drop")
    let load = Button(imageNamed: "load")
    
    // Signs are for warning
    let yellowSign = SKSpriteNode(imageNamed: "YellowSign")
    let redSign = SKSpriteNode(imageNamed: "RedSign")
    
    var droneSound: AVAudioPlayer!
    
    
    override func didMove(to view: SKView) {
        startDeviceMotion()
        drone.addAll(self)
        
        let coeff:CGFloat = GameViewController.sizeCoefficient
        print("coeff", coeff)
        background = childNode(withName: "background")
        background!.physicsBody = SKPhysicsBody(edgeLoopFrom: background!.frame)
        background?.setScale(coeff)
        if let gFrame = background?.childNode(withName: "ground")?.frame {
            let rect = CGRect(x: gFrame.minX*coeff, y: gFrame.minY*coeff, width: gFrame.width*coeff, height: (gFrame.height/2-5)*coeff)
            // create physics body for ground from ground.frame
            let rectNode = SKShapeNode(rect: rect)
            rectNode.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
            rectNode.alpha = 0.0
            self.addChild(rectNode)
        }
        warehouse = background?.childNode(withName: "warehouse")
        if let pos = warehouse?.position {
            drone.body.position = CGPoint(x: pos.x*coeff, y: pos.y*coeff)
        }
        
        //resizeAssets(parent: self, baseName: "cloud", limit: 10)
        if let cloud = childNode(withName: "cloud") {
            cloud.setScale(coeff)
        }
        
        cameraSetup()
        
        //setAudio()
        
    }
    
    @objc func loadPackage() {
        
    }
    
    @objc func dropPackage() {
        
    }
    
    func modifySprite(spriteName: String, alpha: CGFloat) {
        if let node = childNode(withName: spriteName) {
            node.alpha = alpha
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
    
    func setAudio() {
        if let path = Bundle.main.path(forResource: "DroneAudio.aac", ofType: nil) {
            let url = URL(fileURLWithPath: path)
            print(url)
            do {
                droneSound = try AVAudioPlayer(contentsOf: url)
                print(droneSound.play())
            } catch {
                // not sure what to do yet
            }
        }
    }
    
    func addSmoke() {
        let smoke = SKEmitterNode(fileNamed: "Smoke")
        drone.body.addChild(smoke!)
        smoke?.setScale(8.0)
        smoke?.targetNode = self
    }
    
    func resizeAssets(parent: SKNode, baseName: String, limit: Int) {
        // This function is used to loop through assets
        // For example, it will go through building0, building1, building2,...
        // building is the baseName
        // The limit determines the stop of the loop
        for i in 0...limit {
            print(baseName+String(i))
            if let child = parent.childNode(withName: baseName+String(i)) {
                print(child.xScale)
                child.setScale(GameViewController.sizeCoefficient)
                print(child.xScale, child.yScale)
            }
        }
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        }
        drone.startEngine()
        //setAudio()
        dashboardPointer.run(SKAction.rotate(toAngle: power, duration: 2, shortestUnitArc: true)) {
            self.isEngineStarted = true
        }
    }
    
    func cameraSetup() {
        self.camera = cameraNode
        let range = SKRange(lowerLimit: 0, upperLimit: self.frame.maxY-50)
        // minus 50 to give more space to show drone
        let constraint1 = SKConstraint.distance(range, to: drone.body)
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
        dashboard.setScale(GameViewController.sizeCoefficient)
        dashboardPointer.setScale(GameViewController.sizeCoefficient)
        level.setScale(GameViewController.sizeCoefficient)
        line.setScale(GameViewController.sizeCoefficient)
        let center = CGPoint(x: self.frame.maxX-150*GameViewController.sizeCoefficient, y: self.frame.maxY-150*GameViewController.sizeCoefficient)
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
        
        // button
        drop.name = "drop"
        load.name = "load"
        drop.setScale(GameViewController.sizeCoefficient)
        load.setScale(GameViewController.sizeCoefficient)
        drop.position = CGPoint(x: self.frame.minX+100*GameViewController.sizeCoefficient, y: self.frame.minY+100*GameViewController.sizeCoefficient)
        load.position = CGPoint(x: self.frame.minX+100*GameViewController.sizeCoefficient, y: self.frame.minY+200*GameViewController.sizeCoefficient)
        drop.zPosition = 1
        load.zPosition = 1
        cameraNode.addChild(drop)
        cameraNode.addChild(load)
        
        yellowSign.alpha = 0.0
        redSign.alpha = 0.0
        cameraNode.addChild(yellowSign)
        cameraNode.addChild(redSign)
        
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
                        power = power - change*CGFloat.pi/180/drone.powerLimitCoefficient
                        if power <= 0 && power >= -CGFloat.pi {
                            drone.force.dy = drone.force.dy + change
                            dashboardPointer.zRotation = power
                        } else if power > 0 {
                            power = 0
                            drone.force.dy = drone.powerLowerLimit
                            dashboardPointer.zRotation = power
                        } else if power < -CGFloat.pi {
                            power = -CGFloat.pi
                            drone.force.dy = drone.powerUpperLimit
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
            if isTakingUserInput {
                let x = data.attitude.pitch
                //let y = data.attitude.roll
                //let z = data.attitude.yaw
            //let tmp = (z*180/Double.pi).rounded(.toNearestOrAwayFromZero)
                let xD = (x*180/Double.pi).rounded(.toNearestOrAwayFromZero)
            //let yD = (y*180/Double.pi).rounded(.toNearestOrAwayFromZero)
                let rotation = GameViewController.orientation * CGFloat(xD*Double.pi/180)
            // There is a way to offset the rotation by minus the initial rotation when the game first lauches so that the player can play this when they lie down. but I am not going to add it right now
                //print("x:", xD, "y:", yD, "z:", tmp)
                //print(z, tmp, rotation)
                drone.body.zRotation = rotation
                level.zRotation = rotation
            }
            drone.applyForce()
        }
        
        // if drone is too far away from the station, it will loose connectivity to the station and crash.
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.5)
        let fadeInAndOut = SKAction.sequence([fadeIn, fadeOut])
        if let xWarning = background?.frame.maxX {
            if abs(drone.body.position.x) > (xWarning-300) {
                isTakingUserInput = false
                isEngineStarted = false
                drone.force.dy = 0
                dashboardPointer.run(SKAction.rotate(toAngle: 0, duration: 1.0/60.0, shortestUnitArc: true))
            } else if abs(drone.body.position.x) > (xWarning-1000) {
                if !redSign.hasActions() {
                    redSign.run(.repeatForever(fadeInAndOut))
                }
            } else {
                redSign.removeAllActions()
                redSign.alpha = 0.0
            }
        }
        
        if let yWarning = background?.frame.maxY {
            if drone.body.position.y > (yWarning-100) {
                yellowSign.run(.repeatForever(fadeInAndOut))
                drone.force.dy = drone.powerLowerLimit
                dashboardPointer.run(SKAction.rotate(toAngle: 0, duration: 1.0/60.0, shortestUnitArc: true))
            } else if drone.body.position.y > (yWarning-300) {
                if !yellowSign.hasActions() {
                    yellowSign.run(.repeatForever(fadeInAndOut))
                }
            } else {
                yellowSign.removeAllActions()
                yellowSign.alpha = 0.0
            }
        }
        
    }
}
