//
//  Drone.swift
//  Deliver!
//
//  Created by Adam Zhao on 10/3/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import Foundation
import SpriteKit

class Drone {
    let body = SKSpriteNode(imageNamed: "body")     //drone body
    let rotorL = SKSpriteNode(imageNamed: "rotorL") //right rotor
    let rotorR = SKSpriteNode(imageNamed: "Rrotor") //left rotor
    final let PIXELRATIO = CGFloat(150) // pixel ratio of 150 pixels = 1 meter
    let jointL: SKPhysicsJoint
    let jointR: SKPhysicsJoint
    let locationL: SKConstraint
    let locationR: SKConstraint
    let mass: Double
    
    init() {
        mass = 10.0
        
        body.physicsBody = SKPhysicsBody(texture: body.texture!, size: body.texture!.size())
        rotorL.physicsBody = SKPhysicsBody(texture: rotorL.texture!, size: rotorL.texture!.size())
        rotorR.physicsBody = SKPhysicsBody(texture: rotorR.texture!, size: rotorR.texture!.size())
        body.physicsBody?.mass = CGFloat(mass-0.0000001)*PIXELRATIO
        rotorL.physicsBody?.mass = CGFloat(0.00000005*PIXELRATIO)
        rotorR.physicsBody?.mass = CGFloat(0.00000005*PIXELRATIO)
        body.physicsBody?.categoryBitMask = 0b000001
        rotorL.physicsBody?.categoryBitMask = 0b00001
        rotorR.physicsBody?.categoryBitMask = 0b00001
        
        jointL = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: rotorL.physicsBody!, anchor: body.anchorPoint)
        jointR = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: rotorR.physicsBody!, anchor: body.anchorPoint)
        let zero = SKRange(constantValue: 0)
        locationR = SKConstraint.distance(zero, to: CGPoint(x: <#T##Double#>, y: <#T##Double#>), in: body)
        locationL = SKConstraint.distance(zero, to: CGPoint(x: <#T##Double#>, y: <#T##Double#>), in: body)
        rotorR.constraints = [locationR]
        rotorL.constraints = [locationL]
    }
}
