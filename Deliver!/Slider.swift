//
//  Slider.swift
//  Deliver!
//
//  Created by Adam Zhao on 11/1/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import SpriteKit

class Slider: SKSpriteNode {
    let imageName: String
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    init() {
        imageName = "slider"
        let sliderTexture = SKTexture(imageNamed: imageName)
        super.init(texture: sliderTexture, color: UIColor.clear, size: sliderTexture.size())
    }
}
