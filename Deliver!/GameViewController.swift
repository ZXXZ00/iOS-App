//
//  GameViewController.swift
//  Deliver!
//
//  Created by Adam Zhao on 9/2/19.
//  Copyright © 2019 Adam Zhao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{
    
    static var sensitivity: CGFloat = 100.0
    static var sizeCoefficient: CGFloat = 0.75
    static var orientation: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .phone {
            GameViewController.sizeCoefficient = 0.5
        }
        if UIApplication.shared.statusBarOrientation == .landscapeRight {
            GameViewController.orientation = -1 // 1.0 is landscapeLeft
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            print(UserDefaults.standard.double(forKey: "LastRun"))
            if UserDefaults.standard.double(forKey: "LastRun") != 0.0 {
                print("Tutorial")
                if let scene = TutorialScene(fileNamed: "Tutorial") {
                    scene.scaleMode = .aspectFill
                    scene.size = self.view.frame.size
                    view.presentScene(scene)
                }
            } else {
                print("GameScene")
                if let scene = GameScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    scene.size = self.view.frame.size
                    
                    // Present the scene
                    view.presentScene(scene)
                } /*
                let texture1 = SKTexture(imageNamed: "clouds")
                let texture2 = SKTexture(imageNamed: "background")
                let texture = [texture2]
                SKTexture.preload(texture) {
                    SKTexture.preload([texture1]) {
                        
                        DispatchQueue.main.async {
                            let scene = GameScene(size: self.view.frame.size)
                            view.presentScene(scene)
                        }
                    }
                } */
            }
            let date = Date()
            let time: Double = Double(date.timeIntervalSince1970)
            UserDefaults.standard.set(time, forKey: "LastRun")
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            //view.showsPhysics = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
