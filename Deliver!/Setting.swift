//
//  Setting.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/22/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class Setting: SKSpriteNode {
    override var isUserInteractionEnabled: Bool {
        set {
            // ignore
        }
        get {
            return true;
        }
    }
    let interface = SKSpriteNode(imageNamed: "interface")
    let restart = Button(imageNamed: "btn")
    let levels = Button(imageNamed: "btn")
    let menu = Button(imageNamed: "btn")
    let close = Button(imageNamed: "btn_close")
    
    init() {
        //configText(fontName: "ChalkboardSE-Bold", fontColor: .gray, fontSize: 24)
        let buttons = [restart, levels, menu]
        let texts = ["restart", "levels", "menu"]
        for i in 0...buttons.count-1 {
            let label = SKLabelNode(text: texts[i])
            label.fontName = "ChalkboardSE-Bold"
            label.fontColor = .gray
            label.fontSize = 24
            label.zPosition = 1
            buttons[i].addChild(label)
            buttons[i].zPosition = 1
        }
        
        let coeff = GameViewController.sizeCoefficient
        interface.alpha = 0.7
        interface.setScale(coeff)
        //restart.setScale(coeff)
        //restart.target = scene
        restart.action = #selector(GameScene.reset)
        restart.position = CGPoint(x: 0, y: 250*coeff)
        restart.zPosition = 1
        interface.addChild(restart)
        //levels.setScale(coeff)
        //levels.target = scene
        levels.action = #selector(GameScene.nextLevel)
        levels.position = CGPoint(x: 0, y: 0)
        levels.zPosition = 1
        interface.addChild(levels)
        //menu.setScale(coeff)
        //menu.target = scene
        menu.action = #selector(GameScene.backToMenu)
        menu.position = CGPoint(x: 0, y: -250*coeff)
        menu.zPosition = 1
        interface.addChild(menu)
        //close.setScale(coeff)
        //close.target = self
        close.action = #selector(Setting.closeSetting)
        close.position = CGPoint(x: interface.frame.maxX-20*coeff, y: interface.frame.maxY-20*coeff)
        close.zPosition = 1
        interface.addChild(close)
        
        let imageTexture = SKTexture(imageNamed: "setting")
        super.init(texture: imageTexture, color: .clear, size: imageTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    func addToScene(scene: SKScene) {
        scene.physicsWorld.speed = 0
        restart.target = scene
        levels.target = scene
        menu.target = scene
        close.target = self
        if let cameraNode = scene.camera {
            cameraNode.addChild(interface)
        }
    }
    
    @objc func closeSetting() {
        interface.removeFromParent()
        if let owner = self.scene {
            owner.physicsWorld.speed = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
        let loc = touch.location(in: self)
        print(loc)
            if abs(loc.x) <= (self.size.width/2)*1.15 &&
                abs(loc.y) <=  (self.size.height/2)*1.15 {
                if let owner = scene {
                    addToScene(scene: owner)
                }
            }
        }
    }
}
