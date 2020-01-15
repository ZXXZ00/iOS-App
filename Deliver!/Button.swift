//
//  Button.swift
//  Deliver!
//
//  Created by Adam Zhao on 1/10/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    
    var sksFileName: String? // change scene to. The name of sks file
    var isChangingScene: Bool = false // if the button changes scene
    var typeOfScene: String?
    
    var action: Selector?
    var target: AnyObject?
    
    var delegate: ChangeSceneDelegate?
    
    init(imageName: String, sceneName: String?, type: String?) {
        let texture = SKTexture(imageNamed: imageName)
        let color = UIColor(white: 1.0, alpha: 0.0)
        super.init(texture: texture, color: color, size: texture.size())
        sksFileName = sceneName
        if sksFileName != nil {
            isChangingScene = true
        }
        typeOfScene = type
    }
    
    convenience init(imageName: String) {
        self.init(imageName: imageName, sceneName: nil, type: nil)
    }
    
    convenience init(imageName: String, action: Selector, target: AnyObject) {
        self.init(imageName: imageName, sceneName: nil, type: nil)
        self.action = action
        self.target = target
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding Not Supported")
    }

    override var isUserInteractionEnabled: Bool {
        set {
            
        }
        get {
            return true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            print(loc)
            if abs(loc.x) <= self.size.width/2 && abs(loc.y) <=  self.size.height/2 {
                print("inside")
                let test = UIApplication.shared.sendAction(action!, to: target!, from: self, for: nil)
                print(test)
                if isChangingScene {
                    //delegate?.changeScene(sksFilename: sksFileName!, typeOfScene: typeOfScene!)
                }
            }
        }
    }
}
