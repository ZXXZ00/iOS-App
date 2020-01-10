//
//  Drone.swift
//  Deliver!
//
//  Created by Adam Zhao on 10/3/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class Drone {
    let body: SKSpriteNode
    var rotors = [SKSpriteNode]()
    let mass: CGFloat
    var force: CGVector
    var distancesToBody = [CGPoint]()
    var bodyScale: CGFloat = 1.0
    var rotorScale: CGFloat = 1.0
    
    init(droneBodyName: String, collectionOfRotors arr: [(CGPoint, String)]) {
        // it takes the name of the file of the drone body design and collections of rotors, which is an array of tuple.
        //The first part of the tuple is the location of the rotor relative to the center of the drone body. The second part is the file name.
        body = SKSpriteNode(imageNamed: droneBodyName)
        mass = 10 // default mass is 10
               // I will add a method to automatically compute the mass
               // based on the shape and size of the drawing
        if droneBodyName == "body" {
            bodyScale = 0.15*GameViewController.sizeCoefficient
        }
        
        rotorScale = 0.15*GameViewController.sizeCoefficient
        
        force = CGVector(dx: 0.0, dy: GameScene.GRAVITY*GameScene.PIXELRATIO*mass/2)
        let zero = SKRange(constantValue: 0)
        
        for i in arr {
            let rotor = SKSpriteNode(imageNamed: i.1)
            rotor.position = i.0
            rotor.physicsBody = SKPhysicsBody(rectangleOf: rotor.size)
            rotor.physicsBody?.mass = 0.0000000000000001
            rotor.physicsBody?.contactTestBitMask = 0b00000001
            let distance = SKConstraint.distance(zero, to: i.0, in: body)
            let degree = SKRange(constantValue: -atan(i.0.y/i.0.x))
            let orient = SKConstraint.orient(to: body, offset: degree)
            rotor.constraints = [distance, orient] // line up rotor to body
            rotors.append(rotor)
            rotor.setScale(rotorScale)
            distancesToBody.append(i.0)
        }
        
        body.physicsBody = SKPhysicsBody(texture: body.texture!, size: body.texture!.size())
        body.physicsBody?.mass = mass
        body.physicsBody?.contactTestBitMask = 0b00000001
        body.setScale(bodyScale)
    }
    
    
    convenience init() {
        var locations = [(CGPoint, String)]()

        let locationL = CGPoint(x: -183, y: 143)
        let locationR = CGPoint(x: 183, y: 143)
        
        locations.append((locationL, "rotor280"))
        locations.append((locationR, "rotor280"))
        //locations store locations of rotors from left to right
        //rotors also follow the left to right pattern
        
        self.init(droneBodyName: "body", collectionOfRotors: locations)
    }
    
    func addAll(_ scene: SKScene) {
        scene.addChild(body)
        for rotor in rotors {
            scene.addChild(rotor)
        }
    }
    
    func applyForce() {
        let r = body.zRotation
        let bodyP = body.position
        for d in distancesToBody {
            let verticalVector = CGVector(dx: -force.dy*sin(r), dy: force.dy*cos(r))
            let horizontalVector = CGVector(dx: force.dx*cos(r), dy: force.dx*sin(r))
            let position = CGPoint(x: bodyP.x-d.x*cos(r), y: bodyP.y-d.x*sin(r))
            body.physicsBody?.applyForce(verticalVector, at: position)
            body.physicsBody?.applyForce(horizontalVector, at: position)
        }
    }
    
    func startEngine() {
        let negativeRotation = SKAction.scaleX(to: -rotorScale, duration: 0.08)
        let positiveRotation = SKAction.scaleX(to: rotorScale, duration: 0.08)
        let sequence = SKAction.sequence([negativeRotation, positiveRotation])
        for rotor in rotors {
            rotor.run(.repeatForever(sequence))
        }
        rotors[0].run(.repeatForever(sequence))
    }
}

