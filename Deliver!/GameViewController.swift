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
    
    @IBOutlet weak var text: UILabel?
    @IBOutlet weak var button: UIButton?
    static var sensitivity: CGFloat = 100.0
    static var sizeCoefficient: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if UIDevice.current.userInterfaceIdiom == .phone {
            GameViewController.sizeCoefficient = 0.5
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = self.view.frame.size
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        text?.removeFromSuperview()
        button?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    @IBAction func onButtonTap(sender: UIButton){
        text?.text = "AnotherTest"
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
