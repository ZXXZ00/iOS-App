//
//  TutorialSceneRotation.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/17/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class TutorialSceneRotation: GameScene {
    
    let gyro = SKLabelNode(text: "Rotate your screen to change the direction")
    let rotation0 = SKLabelNode(text: "Notice the blue and yellow cirle")
    let rotation1 = SKLabelNode(text: "will also rotate as you rotate")
    let rotation2 = SKLabelNode(text: "your screen. It will help you to")
    let rotation3 = SKLabelNode(text: "maintain the balance of the drone")
    let traveOutOfRange = SKLabelNode(text: "Try to going far east or far west")
    
    
    /*
     
     
     self.gyro.removeFromParent()
     self.rotation0.removeFromParent()
     self.rotation1.removeFromParent()
     self.rotation2.removeFromParent()
     self.rotation3.removeFromParent()
     
     self.cameraNode.addChild(self.rotation0)
     self.cameraNode.addChild(self.rotation1)
     self.cameraNode.addChild(self.rotation2)
     self.cameraNode.addChild(self.rotation3)
     self.gyro.run(fadeAway)
     
     */
    
    
    func configText(fontName: String, fontColor: UIColor, fontSize: CGFloat) {
        let textArr = [gyro, rotation0, rotation1, rotation2, rotation3]
        let names = ["gyro", "rotation0", "rotation1", "rotation2", "rotation3"]
        let coeff = GameViewController.sizeCoefficient
        let locations = ["gyro": CGPoint(x: 0, y: 0),
                     "rotation0": CGPoint(x: frame.maxX-230*coeff, y: frame.maxY-300*coeff),
                     "rotation1": CGPoint(x: frame.maxX-230*coeff, y: frame.maxY-325*coeff),
                     "rotation2": CGPoint(x: frame.maxX-230*coeff, y: frame.maxY-350*coeff),
                     "rotation3": CGPoint(x: frame.maxX-230*coeff, y: frame.maxY-375*coeff)]
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
