//
//  ButtonDelegate.swift
//  Deliver!
//
//  Created by Adam Zhao on 1/15/20.
//  Copyright © 2020 Adam Zhao. All rights reserved.
//

protocol ButtonDelegate {
    func changeScene(sksFilename: String, typeOfScene: String)
    func changeElement(name: String)
}
