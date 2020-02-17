//
//  TutorialScene.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/10/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class TutorialScene: GameScene {
    
    let welcome = SKLabelNode(text: "Welcome to Drone! \nLet's follow this tutorial to learn to how control the drone and deliver pacakge.")
    let startEngine = SKLabelNode(text: "First click screen to start the engine.")
    let enginePower = SKLabelNode(text: "Swipe up down on the right side of your screen to control the engine power.")
    let dashboardExplain = SKLabelNode(text: "When it is flying at 50% of power, upward force is equal to the weight of the drone")
    let increaseToMax = SKLabelNode(text: "Try to increase the power to maixmum")
    let heightWarning = SKLabelNode(text: "If you reach too high")
    let gyro = SKLabelNode(text: "Rotate your screen to change the direction")
    
    /*
    let locations = ["welcom": CGPoint(x: 0, y: 0),
                     "startEngine": CGPoint(x: 0,y: -100*GameViewController.sizeCoefficient),
                     "enginePower": CGPoint(x: 250*GameViewController.sizeCoefficient, y: 200*GameViewController.sizeCoefficient),
                     "dashboardExplain": CGPoint(x: 150*GameViewController.sizeCoefficient, y: 250*GameViewController.sizeCoefficient),
                     "gryo": CGPoint(x: 0, y: 0)]
 */
    let arrowUP = SKSpriteNode(imageNamed: "arrow_big")
    let arrowDown = SKSpriteNode(imageNamed: "arrow_big")
    let rightSide = SKShapeNode(rectOf: CGSize(width: 2000, height: 2000))
    let smallArrow = SKSpriteNode(imageNamed: "arrow_sm")
    
    override func didMove(to view: SKView) {
        isTakingUserInput = false
        drone.body.physicsBody?.allowsRotation = false
        super.didMove(to: view)
        configText(fontName: "ChalkboardSE-Bold", fontColor: .white, fontSize: 24*GameViewController.sizeCoefficient)
        cameraNode.addChild(welcome)
        cameraNode.addChild(startEngine)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEngineStarted) {
            startDeviceMotion()
        }
        if let _ = cameraNode.childNode(withName: "welcome") {
            welcome.removeFromParent()
            startEngine.removeFromParent()
            cameraNode.addChild(enginePower)
            
            arrowDown.zRotation = CGFloat.pi
            arrowUP.position = CGPoint(x: frame.maxX/2, y: 75*GameViewController.sizeCoefficient)
            arrowDown.position = CGPoint(x: frame.maxX/2, y: -75*GameViewController.sizeCoefficient)
            arrowUP.setScale(GameViewController.sizeCoefficient)
            arrowDown.setScale(GameViewController.sizeCoefficient)
            cameraNode.addChild(arrowUP)
            cameraNode.addChild(arrowDown)
            
            rightSide.position = CGPoint(x: 1000, y: 0)
            rightSide.fillColor = .gray
            rightSide.alpha = 0.2
            cameraNode.addChild(rightSide)
            
            smallArrow.position = CGPoint(x: 420*GameViewController.sizeCoefficient, y: 315*GameViewController.sizeCoefficient)
            smallArrow.zRotation = -CGFloat.pi/2
            smallArrow.setScale(GameViewController.sizeCoefficient)
                        
            let queue = DispatchQueue(label: "instruction")
            queue.async {
                sleep(3)
                self.cameraNode.addChild(self.dashboardExplain)
                self.cameraNode.addChild(self.smallArrow)
                sleep(10)
                self.arrowUP.removeFromParent()
                self.arrowDown.removeFromParent()
                self.enginePower.removeFromParent()
                self.dashboardExplain.removeFromParent()
                self.smallArrow.removeFromParent()
                self.rightSide.removeFromParent()
            }
            
        }
    }
    
    func configText(fontName: String, fontColor: UIColor, fontSize: CGFloat) {
        let textArr = [welcome, startEngine, enginePower, dashboardExplain, gyro]
        let names = ["welcome", "startEngine", "enginePower", "dashboardExplain", "increaseToMax", "gryo"]
        let coeff = GameViewController.sizeCoefficient
        //let textLocations = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: -100*coeff), CGPoint(x: 250*coeff, y: 200*coeff), CGPoint(x: 0, y: 0)]
        let locations = ["welcom": CGPoint(x: 0, y: 0),
                         "startEngine": CGPoint(x: 0,y: -100*coeff),
                         "enginePower": CGPoint(x: 250*coeff, y: -5*coeff),
                         "dashboardExplain": CGPoint(x: -130*coeff, y: 310*coeff),
                         "increaseToMax": CGPoint(x: 300*coeff, y: 0),
                         "gryo": CGPoint(x: 0, y: 0)]
        for i in 0...textArr.count-1 {
            textArr[i].name = names[i]
            textArr[i].fontName = fontName
            textArr[i].fontColor = fontColor
            textArr[i].fontSize = fontSize
            if let pos = locations[names[i]] {
                textArr[i].position = pos
            }
            //textArr[i].zPosition = 1
        }
    }
}
