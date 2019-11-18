//
//  Slider.swift
//  Deliver!
//
//  Created by Adam Zhao on 11/1/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class Slider: SKSpriteNode {
    let imageName = "slider"
    let knob = SKSpriteNode(imageNamed: "knob")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    init() {
        let sliderTexture = SKTexture(imageNamed: imageName)
        super.init(texture: sliderTexture, color: UIColor.clear, size: sliderTexture.size())
        let zero = SKRange(constantValue: 0)
        //let xConstraint =
    }
}
