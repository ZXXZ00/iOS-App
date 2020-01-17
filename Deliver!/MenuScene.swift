//
//  MenuScene.swift
//  Deliver!
//
//  Created by Adam Zhao on 10/31/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene{
    
    @objc func startGame() {
        if let scene = GameScene(fileNamed: "GameScene") {
            self.view?.presentScene(scene)
        }
    }
    
    override func didMove(to view: SKView) {
        let start = Button(imageNamed: "start")
        start.target = self
        start.action = #selector(MenuScene.startGame)
        addChild(start)
    }
    
}
