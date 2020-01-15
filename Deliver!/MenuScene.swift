//
//  MenuScene.swift
//  Deliver!
//
//  Created by Adam Zhao on 10/31/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene{
    
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
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
