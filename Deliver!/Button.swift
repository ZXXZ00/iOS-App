//
//  Button.swift
//  Deliver!
//
//  Created by Adam Zhao on 1/15/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    var action: Selector? = nil
    var target: AnyObject? = nil
    var isInteractive: Bool = true
    
    override var isUserInteractionEnabled: Bool {
        set {
            
        }
        get {
            return isInteractive
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            print(loc)
            if abs(loc.x) <= self.size.width/2 &&
                abs(loc.y) <=  self.size.height/2 {
                print("inside")
                if let action = action, let target = target {
                    UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
                }
            }
        }
    }
}


