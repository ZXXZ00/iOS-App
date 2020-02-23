//
//  TutorialScene.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/10/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class TutorialSceneEngine: GameScene {
    
    let welcome = SKLabelNode(text: "Welcome to Drone! Let's follow this tutorial to learn to how control the drone.")
    let light = SKLabelNode(text: "Engine indication light")
    let startEngine = SKLabelNode(text: "First click screen to start the engine.")
    let enginePower = SKLabelNode(text: "Swipe up or down on the right side of your screen to control the engine power.")
    let dashboardExplain = SKLabelNode(text: "When it is flying at 50% of power, upward force is equal to the weight of the drone")
    let increaseToMax = SKLabelNode(text: "Try to swipe up several times to increase the power to maixmum.")
    let heightWarning = SKLabelNode(text: "If you reach too high, you will see a yellow sign, it means you are too high.")
    let enginePowerExplain0 = SKLabelNode(text: "When the dial points to 0, it doesn't mean engine is completely shut off.")
    let enginePowerExplain1 = SKLabelNode(text: "Only when the engine indication light is off, the engine is completely shut off.")
    let yellowSignMeaning = SKLabelNode(text: "If you don't lower its height, engine is going to decrease its power and engine indication light will blink.")
    let attentionToDial = SKLabelNode(text: "Pay attention to the dial.")
    let finished0 = SKLabelNode(text: "Congradulations! You finished the tutorial part 1.")
    let finished1 = SKLabelNode(text: "You can play around or continue to tutorial part 2 by tapping the arrow.")
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
    let nextButton = Button(imageNamed: "arrow_big")
    
    override func didMove(to view: SKView) {
        isTakingUserInput = false
        drone.body.physicsBody?.allowsRotation = false
        super.didMove(to: view)
        configText(fontName: "ChalkboardSE-Bold", fontColor: .white, fontSize: 28*GameViewController.sizeCoefficient)
        cameraNode.addChild(welcome)
        smallArrow.position = CGPoint(x: frame.maxX-255*GameViewController.sizeCoefficient, y: frame.maxY-285*GameViewController.sizeCoefficient)
        smallArrow.setScale(GameViewController.sizeCoefficient)
        cameraNode.addChild(smallArrow)
        cameraNode.addChild(light)
        cameraNode.addChild(startEngine)
        load.alpha = 0.0
        drop.alpha = 0.0
    }
    
    @objc func continueTutorial() { // continue to the next part of the tutorial
        if let scene = TutorialSceneRotation(fileNamed: "Tutorial.sks") {
            scene.currentSceneName = "Tutorial"
            view?.presentScene(scene, transition: SKTransition.fade(with: .black, duration: 3))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEngineStarted) {
            startDeviceMotion()
        }
        if let _ = cameraNode.childNode(withName: "welcome") {
            welcome.removeFromParent()
            light.removeFromParent()
            smallArrow.removeFromParent()
            startEngine.removeFromParent()
            cameraNode.addChild(enginePower)
            
            arrowDown.zRotation = CGFloat.pi
            arrowUP.position = CGPoint(x: frame.maxX/2, y: 75*GameViewController.sizeCoefficient)
            arrowDown.position = CGPoint(x: frame.maxX/2, y: -75*GameViewController.sizeCoefficient)
            arrowUP.setScale(GameViewController.sizeCoefficient)
            arrowDown.setScale(GameViewController.sizeCoefficient)
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeInAndOut = SKAction.sequence([fadeIn, fadeOut])
            arrowUP.run(.repeatForever(fadeInAndOut))
            arrowDown.run(.repeatForever(fadeInAndOut))
            cameraNode.addChild(arrowUP)
            cameraNode.addChild(arrowDown)
            
            rightSide.position = CGPoint(x: 1000, y: 0)
            rightSide.fillColor = .gray
            rightSide.alpha = 0.2
            cameraNode.addChild(rightSide)
            
            smallArrow.position = CGPoint(x: frame.maxX-274*GameViewController.sizeCoefficient, y: frame.maxY-232*GameViewController.sizeCoefficient)
            smallArrow.zRotation = -CGFloat.pi/2
                        
            let queue = DispatchQueue(label: "instruction")
            queue.async {
                sleep(5)
                self.arrowDown.removeAllActions()
                self.arrowUP.removeAllActions()
                self.arrowUP.removeFromParent()
                self.arrowDown.removeFromParent()
                self.cameraNode.addChild(self.dashboardExplain)
                self.cameraNode.addChild(self.smallArrow)
                sleep(5)
                let fadeAway = SKAction.fadeOut(withDuration: 3)
                self.enginePower.run(fadeAway)
                sleep(3)
                self.cameraNode.addChild(self.attentionToDial)
                sleep(2)
                self.enginePower.removeFromParent()
                self.dashboardExplain.removeFromParent()
                self.smallArrow.removeFromParent()
                self.rightSide.removeFromParent()
                self.cameraNode.addChild(self.increaseToMax)
                sleep(1)
                self.heightWarning.alpha = 0
                self.yellowSignMeaning.alpha = 0
                self.cameraNode.addChild(self.heightWarning)
                self.cameraNode.addChild(self.yellowSignMeaning)
                self.heightWarning.run(fadeIn)
                self.yellowSignMeaning.run(fadeIn)
                sleep(1)
                if let sign = self.cameraNode.childNode(withName: "yellowSign") {
                    while sign.alpha == 0 {
                        sleep(1)
                    }
                }
                self.increaseToMax.run(fadeAway) {
                    self.increaseToMax.removeFromParent()
                }
                self.heightWarning.run(fadeAway) {
                    self.heightWarning.removeFromParent()
                }
                self.yellowSignMeaning.run(fadeAway) {
                    self.yellowSignMeaning.removeFromParent()
                }
                self.cameraNode.addChild(self.enginePowerExplain0)
                self.cameraNode.addChild(self.enginePowerExplain1)
                sleep(7)
                self.enginePowerExplain0.removeFromParent()
                self.enginePowerExplain1.removeFromParent()
                sleep(2)
                self.attentionToDial.run(fadeAway) {
                    self.attentionToDial.removeFromParent()
                }
                self.cameraNode.addChild(self.finished0)
                self.cameraNode.addChild(self.finished1)
                self.nextButton.zRotation = -CGFloat.pi/2
                self.nextButton.setScale(GameViewController.sizeCoefficient)
                self.nextButton.action = #selector(TutorialSceneEngine.continueTutorial)
                self.nextButton.target = self
                self.cameraNode.addChild(self.nextButton)
            }
            
        }
    }
    
    func configText(fontName: String, fontColor: UIColor, fontSize: CGFloat) {
        let textArr = [welcome, light, startEngine, enginePower, dashboardExplain, increaseToMax, heightWarning, enginePowerExplain0, enginePowerExplain1, yellowSignMeaning, attentionToDial, finished0, finished1]
        let names = ["welcome", "light", "startEngine", "enginePower", "dashboardExplain", "increaseToMax", "heightWarning", "enginePowerExplain0", "enginePowerExplain1", "yellowSignMeaning", "attentionToDial", "finished0", "finished1"]
        let coeff = GameViewController.sizeCoefficient
        let locations = ["welcom": CGPoint(x: 0, y: 0),
                         "light": CGPoint(x: frame.maxX-255*coeff, y: frame.maxY-340*coeff),
                         "startEngine": CGPoint(x: 0,y: -100*coeff),
                         "enginePower": CGPoint(x: 150*coeff, y: -5*coeff),
                         "dashboardExplain": CGPoint(x: -130*coeff, y: frame.maxY-232*coeff),
                         "increaseToMax": CGPoint(x: 0, y: 200*coeff),
                         "heightWarning": CGPoint(x: 0, y: 50*coeff),
                         "enginePowerExplain0": CGPoint(x: 0, y: -50*coeff),
                         "enginePowerExplain1": CGPoint(x: 0, y: -80*coeff),
                         "yellowSignMeaning": CGPoint(x: 0, y: 20*coeff),
                         "attentionToDial": CGPoint(x: frame.maxX-230*coeff, y: frame.maxY-300*coeff),
                         "finished0": CGPoint(x:0, y: 100*coeff),"finished1": CGPoint(x: 0, y:50*coeff)]
        for i in 0...textArr.count-1 {
            textArr[i].name = names[i]
            textArr[i].fontName = fontName
            textArr[i].fontColor = fontColor
            textArr[i].fontSize = fontSize
            if let pos = locations[names[i]] {
                textArr[i].position = pos
            }
            textArr[i].zPosition = 9
        }
    }
}
