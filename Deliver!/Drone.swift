//
//  Drone.swift
//  Deliver!
//
//  Created by Adam Zhao on 10/3/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class Drone {
    let body = SKSpriteNode(imageNamed: "body")     //drone body
    let rotorL = SKSpriteNode(imageNamed: "rotorL") //right rotor
    let rotorR = SKSpriteNode(imageNamed: "rotorR") //left rotor
    let jointL: SKPhysicsJoint
    let jointR: SKPhysicsJoint
    let constraintL: SKConstraint
    let constraintR: SKConstraint
    let mass: CGFloat
    var force: CGVector
    let locationL: (x: CGFloat, y: CGFloat)
    let locationR: (x: CGFloat, y: CGFloat)
    
    init() {
        locationL = (x: 0, y: 0)
        locationR = (x: 0, y: 0)
        
        mass = 10.0
        
        body.physicsBody = SKPhysicsBody(texture: body.texture!, size: body.texture!.size())
        rotorL.physicsBody = SKPhysicsBody(texture: rotorL.texture!, size: rotorL.texture!.size())
        rotorR.physicsBody = SKPhysicsBody(texture: rotorR.texture!, size: rotorR.texture!.size())
        body.physicsBody?.mass = CGFloat(mass-0.0000001)*GameScene.PIXELRATIO
        rotorL.physicsBody?.mass = CGFloat(0.00000005*GameScene.PIXELRATIO)
        rotorR.physicsBody?.mass = CGFloat(0.00000005*GameScene.PIXELRATIO)
        body.physicsBody?.categoryBitMask = 0b000001
        rotorL.physicsBody?.categoryBitMask = 0b00001
        rotorR.physicsBody?.categoryBitMask = 0b00001
        
        rotorL.physicsBody?.isDynamic = false
        rotorR.physicsBody?.isDynamic = false
        
        jointL = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: rotorL.physicsBody!, anchor: body.anchorPoint)
        jointR = SKPhysicsJointFixed.joint(withBodyA: body.physicsBody!, bodyB: rotorR.physicsBody!, anchor: body.anchorPoint)
        let zero = SKRange(constantValue: 0)
        constraintR = SKConstraint.distance(zero, to: CGPoint(x: locationR.x, y: locationR.y), in: body)
        constraintL = SKConstraint.distance(zero, to: CGPoint(x: locationL.x, y: locationL.y), in: body)
        rotorR.constraints = [constraintR]
        rotorL.constraints = [constraintL]
        
        force = CGVector(dx: 0, dy: GameScene.GRAVITY*GameScene.PIXELRATIO*mass/2)
    }
    
    func applyForce() {
        let r = body.zRotation
        let pos = body.position
        let pL = CGPoint(x: pos.x-locationL.x*cos(r), y: pos.y-locationL.x*sin(r))
        let pR = CGPoint(x: pos.x+locationR.x*cos(r), y: pos.y+locationR.x*sin(r))
        let vL = CGVector(dx: -force.dy*sin(r), dy: force.dy*cos(r)*150)
        let vR = CGVector(dx: -force.dy*sin(r), dy: force.dy*cos(r)*150)
        body.physicsBody?.applyForce(vL, at: pL)
        body.physicsBody?.applyForce(vR, at: pR)
    }
}
