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
    
    var mode = "normal" // there are two mode now, entry and normal
    
    var currentSceneName = ""
    var nextSceneName = ""
    
    let drone = Drone()
    var initalPosition = CGPoint(x: 0, y: 0)
    static let gravity = CGFloat(9.8)
    static let PIXELRATIO = CGFloat(150)
    // pixel ratio of 150 pixels = 1 meter
    let motion = CMMotionManager()
    var isTakingUserInput = true
    var isEngineStarted = false {
        didSet {
            if isEngineStarted {
                lightOn.alpha = 1
                lightOff.alpha = 0
            } else {
                lightOn.alpha = 0
                lightOff.alpha = 1
                for rotor in drone.rotors {
                    rotor.removeAllActions()
                }
            }
        }
    }
    var start = true
    var startTime = 0.0
    var t = 0.0 // t stands for time
    var dt: CGFloat = 0.0 // dt is change in time
    var previousTime: TimeInterval = 0.0
    var dx: CGFloat = 0.0 // dx is change in x direction
    let lightOn = SKSpriteNode(imageNamed: "light_on")
    let lightOff = SKSpriteNode(imageNamed: "light_off")
    let cameraNode = SKCameraNode()
    var background: SKNode?
    var warehouse: SKSpriteNode?
    var houses: [SKNode] = []
    var boxes: [SKNode] = []
    var gears: [SKNode] = []
    // SKSpriteNode below are dashboard section
    let dashboard = SKSpriteNode(imageNamed: "dashboard")
    let dashboardPointer = SKSpriteNode(imageNamed: "pointer")
    let level = SKSpriteNode(imageNamed: "level")
    let line = SKSpriteNode(imageNamed: "line")
    let setting = Setting()
    var power = -CGFloat.pi/2 // rotation of dashboardPointer
    // Below are buttons in the game
    let drop = Button(imageNamed: "drop")
    let load = Button(imageNamed: "load")
    
    // Signs are for warning
    let yellowSign = SKSpriteNode(imageNamed: "YellowSign")
    let redSign = SKSpriteNode(imageNamed: "RedSign")
    
    var droneSound: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
    
        //startDeviceMotion()
        drone.addAll(self)
        
        setupSKS()
        
        cameraSetup()
        
        //setAudio()
        physicsWorld.contactDelegate = self
        
        if mode == "entry" {
            load.alpha = 0
            drop.alpha = 0
        }
    }
    
    @objc func loadPackage() {
        let box = SKSpriteNode(imageNamed: "box")
        box.name = "box\(boxes.count)"
        boxes.append(box)
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
    }
    
    @objc func dropPackage() {
        let box = boxes.removeLast()
        box.position = drone.body.position
        box.alpha = 0;
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        addChild(box)
        box.run(fadeIn)
        box.physicsBody?.isDynamic = true
    }
    
    // basic setup for nodes in sks file
    func setupSKS () {
        let coeff:CGFloat = GameViewController.sizeCoefficient
        print("coeff", coeff)
        background = childNode(withName: "background")
        background!.physicsBody = SKPhysicsBody(edgeLoopFrom: background!.frame)
        background?.physicsBody?.contactTestBitMask = CategoryMask.drone.rawValue
        background?.setScale(coeff)
        if let gFrame = background?.childNode(withName: "ground")?.frame {
            let rect = CGRect(x: gFrame.minX*coeff, y: gFrame.minY*coeff, width: gFrame.width*coeff, height: (gFrame.height/2-5)*coeff)
            // create physics body for ground from ground.frame
            let rectNode = SKShapeNode(rect: rect)
            rectNode.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
            rectNode.alpha = 0.0
            rectNode.physicsBody?.isDynamic = false
            rectNode.physicsBody?.contactTestBitMask = CategoryMask.drone.rawValue
            self.addChild(rectNode)
        }
        warehouse = background?.childNode(withName: "warehouse") as? SKSpriteNode
        //warehouse!.physicsBody = SKPhysicsBody(texture: warehouse!.texture!, size: warehouse!.texture!.size())
        //warehouse!.physicsBody?.isDynamic = false
        if let pos = warehouse?.position {
            initalPosition = CGPoint(x: (pos.x+25)*coeff, y: (pos.y+111)*coeff)
            drone.body.position = initalPosition
        }
        if let childrens = background?.children {
            for house in childrens {
                if let name = house.name {
                    if name.prefix(5) == "house" {
                        for mask in house.children {
                            mask.physicsBody?.contactTestBitMask = CategoryMask.drone.rawValue
                        }
                        houses.append(house)
                    }
                }
            }
        }
        
        if let cloud = childNode(withName: "cloud") {
            cloud.setScale(coeff)
        }
        gear()
    }
    
    // the next two methods may not be useful
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
    /*
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
    */
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0/60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        }
        drone.startEngine()
        //setAudio()
        dashboardPointer.run(SKAction.rotate(toAngle: power, duration: 0.5, shortestUnitArc: true)) {
            self.isEngineStarted = true
        }
    }
    
    func cameraSetup() {
        let coeff = GameViewController.sizeCoefficient
        self.camera = cameraNode
        cameraNode.zPosition = 5
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
        dashboard.setScale(coeff)
        dashboardPointer.setScale(coeff)
        level.setScale(coeff)
        line.setScale(coeff)
        let center = CGPoint(x: self.frame.maxX-150*coeff, y: self.frame.maxY-140*coeff)
        dashboard.position = center
        dashboardPointer.position = center
        level.position = center
        line.position = center
        dashboard.zPosition = 3
        dashboardPointer.zPosition = 5
        level.zPosition = 5
        line.zPosition = 6
        cameraNode.addChild(dashboard)
        cameraNode.addChild(dashboardPointer)
        cameraNode.addChild(level)
        cameraNode.addChild(line)
        // indication light
        lightOn.setScale(coeff)
        lightOff.setScale(coeff)
        let lightPosition = CGPoint(x: self.frame.maxX-255*coeff, y: self.frame.maxY-245*coeff)
        lightOn.position = lightPosition
        lightOff.position = lightPosition
        lightOn.zPosition = 6
        lightOff.zPosition = 7
        lightOn.alpha = 0
        cameraNode.addChild(lightOn)
        cameraNode.addChild(lightOff)
        
        // button
        drop.name = "drop"
        load.name = "load"
        drop.setScale(coeff)
        load.setScale(coeff)
        drop.position = CGPoint(x: self.frame.minX+100*coeff, y: self.frame.minY+100*coeff)
        load.position = CGPoint(x: self.frame.minX+100*coeff, y: self.frame.minY+200*coeff)
        drop.zPosition = 4
        load.zPosition = 4
        cameraNode.addChild(drop)
        cameraNode.addChild(load)
        
        load.action = #selector(GameScene.reset)
        load.target = self
        
        setting.setScale(coeff)
        setting.zPosition = 9
        setting.position = CGPoint(x: self.frame.maxX-50*coeff, y: self.frame.maxY-50*coeff)
        cameraNode.addChild(setting)
        
        // warning signs
        yellowSign.name = "yellowSign"
        redSign.name = "redSign"
        yellowSign.alpha = 0.0
        redSign.alpha = 0.0
        cameraNode.addChild(yellowSign)
        cameraNode.addChild(redSign)
        
        // setting button
        
        addChild(cameraNode)
    }
    
    @objc func reset() {
        if let scene = GameScene(fileNamed: currentSceneName) {
            scene.currentSceneName = currentSceneName
            scene.nextSceneName = nextSceneName
            view?.presentScene(scene, transition: SKTransition.fade(with: .black, duration: 2))
        }
    }
    
    @objc func nextLevel() {
        if let scene = GameScene(fileNamed: nextSceneName) {
            let level = UserDefaults.standard.integer(forKey: "level")
            scene.currentSceneName = nextSceneName
            scene.nextSceneName = "level\(level+1)"
            view?.presentScene(scene, transition: SKTransition.fade(with: .black, duration: 2))
        }
    }
    
    @objc func backToMenu() {
        if let scene = MenuScene(fileNamed: "MenuScene") {
            view?.presentScene(scene, transition: SKTransition.fade(with: .black, duration: 2))
        }
    }

    func crash() {
        addSmoke()
        isTakingUserInput = false
        isEngineStarted = false
    }
    
    func gear() {
        if let childrens = background?.children {
            for gear in childrens {
                if let name = gear.name {
                    if name == "gear" {
                        gear.physicsBody?.categoryBitMask = CategoryMask.gear.rawValue
                        gear.physicsBody?.contactTestBitMask = CategoryMask.drone.rawValue
                        gear.physicsBody?.collisionBitMask = 0b0000
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isEngineStarted {
            startDeviceMotion()
        }
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
        //reset()
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
            if isEngineStarted {
                drone.applyForce()
            }
        }
        
        // if drone is too far away from the station, it will loose connectivity to the station and crash.
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: 0.4)
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.4)
        let fadeInAndOut = SKAction.sequence([fadeIn, fadeOut])
        if let xWarning = background?.frame.maxX {
            if abs(drone.body.position.x) > (xWarning-300) {
                isTakingUserInput = false
                isEngineStarted = false
                drone.force.dy = 0
                dashboardPointer.run(SKAction.rotate(toAngle: 0, duration: 1.0/60.0, shortestUnitArc: true))
                /*for rotor in drone.rotors {
                    rotor.removeAllActions()
                    rotor.xScale = drone.rotorScale
                } */
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
                if !lightOff.hasActions() {
                    //lightOff.run(.repeatForever(fadeInAndOut))
                lightOff.run(.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 0.1), SKAction.fadeAlpha(to: 0.0, duration: 0.1)])))
                }
                if !yellowSign.hasActions() {
                    yellowSign.run(.repeatForever(fadeInAndOut))
                }
                drone.force.dy = drone.powerLowerLimit
                dashboardPointer.run(SKAction.rotate(toAngle: 0, duration: 1.0/60.0, shortestUnitArc: true))
                power = 0
            } else if drone.body.position.y > (yWarning-300) {
                if !yellowSign.hasActions() {
                    yellowSign.run(.repeatForever(fadeInAndOut))
                }
            } else {
                if lightOff.hasActions() {
                    lightOff.removeAllActions()
                    lightOff.alpha = 0
                }
                if yellowSign.hasActions() {
                    yellowSign.removeAllActions()
                }
                yellowSign.alpha = 0.0
            }
        }
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = CategoryMask(rawValue: contact.bodyA.categoryBitMask)
        let maskB = CategoryMask(rawValue: contact.bodyB.categoryBitMask)
        switch maskA {
        case .body:
            if contact.collisionImpulse > 5700 {
                print(contact.collisionImpulse)
                crash()
            }
        case .rotor:
            if contact.collisionImpulse > 5700 {
                print(contact.collisionImpulse)
                crash()
            }
        case .gear:
            print("gear")
            contact.bodyA.node?.removeFromParent()
        default:
            break
        }
        switch maskB {
        case .body:
            if contact.collisionImpulse > 5700 {
                print(contact.collisionImpulse)
                crash()
            }
        case .rotor:
            if contact.collisionImpulse > 5700 {
                print(contact.collisionImpulse)
                crash()
            }
        case .gear:
            print("gear")
            contact.bodyB.node?.removeFromParent()
        default:
            break
        }
    }
}
