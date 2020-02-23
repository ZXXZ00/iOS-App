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
        let level = UserDefaults.standard.integer(forKey: "level") + 1
        if let scene = GameScene(fileNamed: "Level\(level)") {
            scene.currentSceneName = "Level\(level)"
            scene.nextSceneName = "level\(level+1)"
            view?.presentScene(scene, transition: SKTransition.fade(with: .black, duration: 3))
        }
    }
    
    override func didMove(to view: SKView) {
        let coeff = 0.5*GameViewController.sizeCoefficient
        if let background = childNode(withName: "background") {
            let pos = CGPoint(x: 0, y: background.frame.maxY*coeff-self.frame.maxY)
            background.position = pos
            background.setScale(coeff)
        }
        
        let start = Button(imageNamed: "start")
        start.setScale(GameViewController.sizeCoefficient*1.5)
        start.target = self
        start.action = #selector(MenuScene.startGame)
        addChild(start)
        
        let title = SKSpriteNode(imageNamed: "title")
        title.setScale(GameViewController.sizeCoefficient*1.5)
        title.position = CGPoint(x: 0, y: 200*GameViewController.sizeCoefficient)
        addChild(title)
    }
    
}
