//
//  TutorialSceneRotation.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/17/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class TutorialSceneRotation: GameScene {
    
    let welcome = SKLabelNode(text: "This is part 2 of the tutorial, in this part, you will learn how to control the flight path of the drone")
    let gyro = SKLabelNode(text: "Rotate your screen to change the direction")
    let rotation0 = SKLabelNode(text: "Notice the blue and yellow cirle")
    let rotation1 = SKLabelNode(text: "will also rotate as you rotate")
    let rotation2 = SKLabelNode(text: "your screen. It will help you to")
    let rotation3 = SKLabelNode(text: "maintain the balance of the drone")
    let traveOutOfRange = SKLabelNode(text: "Try to going far east or far west")
    let redWarning = SKLabelNode(text: "If you travel too far away from the base station, you will see a red warning sign.")
    let consequence0 = SKLabelNode(text: "It means you will lose connection to the base station soon if you don't bring it back.")
    let consequence1 = SKLabelNode(text: "Once you are out of range, engine is going to shut off completely.")
    let congrat = SKLabelNode(text: "Congradulations! You finished the tutorial")
    let explore = SKLabelNode(text: "Click the arrow to exist.")
    
    let arrow = Button(imageNamed: "arrow_big")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configText(fontName: "ChalkboardSE-Bold", fontColor: .white, fontSize: 28*GameViewController.sizeCoefficient)
        cameraNode.addChild(welcome)
        load.alpha = 0.0
        drop.alpha = 0.0
        setting.alpha = 0.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEngineStarted) {
            startDeviceMotion()
        }
        if let _ = cameraNode.childNode(withName: "welcome") {
            welcome.removeFromParent()
            let queue = DispatchQueue(label: "instruction")
            queue.async {
                self.cameraNode.addChild(self.gyro)
                sleep(2)
                self.cameraNode.addChild(self.rotation0)
                self.cameraNode.addChild(self.rotation1)
                self.cameraNode.addChild(self.rotation2)
                self.cameraNode.addChild(self.rotation3)
                sleep(5)
                self.gyro.removeFromParent()
                self.cameraNode.addChild(self.traveOutOfRange)
                self.cameraNode.addChild(self.redWarning)
                self.cameraNode.addChild(self.consequence0)
                self.cameraNode.addChild(self.consequence1)
                if let sign = self.cameraNode.childNode(withName: "redSign") {
                    while sign.alpha == 0 {
                        sleep(1)
                    }
                }
                self.traveOutOfRange.removeFromParent()
                self.redWarning.removeFromParent()
                self.consequence0.removeFromParent()
                self.consequence1.removeFromParent()
                self.cameraNode.addChild(self.congrat)
                self.cameraNode.addChild(self.explore)
                self.arrow.setScale(GameViewController.sizeCoefficient)
                self.arrow.zRotation = CGFloat.pi/2
                self.arrow.target = self
                self.arrow.action = #selector(GameScene.backToMenu)
                self.cameraNode.addChild(self.arrow)
            }
        }
    }
    
    func configText(fontName: String, fontColor: UIColor, fontSize: CGFloat) {
        let textArr = [welcome, gyro, rotation0, rotation1, rotation2, rotation3, traveOutOfRange, redWarning, consequence0, consequence1, congrat, explore]
        let names = ["welcome", "gyro", "rotation0", "rotation1", "rotation2", "rotation3", "traveOutOfRange", "redWarning", "consequence0", "consequence1", "congrat", "explore"]
        let coeff = GameViewController.sizeCoefficient
        let locations = ["welcome": CGPoint(x: 0, y: 0),
                         "gyro": CGPoint(x: -50*coeff, y: 0*coeff),
                         "rotation0": CGPoint(x: frame.maxX-300*coeff, y: frame.maxY-300*coeff),
                         "rotation1": CGPoint(x: frame.maxX-300*coeff, y: frame.maxY-325*coeff),
                         "rotation2": CGPoint(x: frame.maxX-300*coeff, y: frame.maxY-350*coeff),
                         "rotation3": CGPoint(x: frame.maxX-300*coeff, y: frame.maxY-375*coeff),
                         "traveOutOfRange": CGPoint(x: 0, y: 200*coeff),
                         "redWarning": CGPoint(x: 0, y: -50*coeff),
                         "consequence0": CGPoint(x: 0, y: -75),
                         "consequence1": CGPoint(x:0, y: -100*coeff),
                         "congrat": CGPoint(x: 0, y: -50*coeff),
                         "explore": CGPoint(x: 0, y: -100*coeff)]
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
