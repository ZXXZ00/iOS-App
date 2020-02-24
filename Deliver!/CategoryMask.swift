//
//  Category.swift
//  Deliver!
//
//  Created by Adam Zhao on 2/22/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

enum CategoryMask: UInt32 {
    case drone = 0b0011
    case body = 0b0001
    case rotor = 0b0010
    case gear = 0b0100
    case landingDeck = 0b1000
}
