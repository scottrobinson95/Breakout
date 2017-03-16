//
//  GameViewController.swift
//  BreakoutProject
//
//  Created by Srobinson1 on 3/16/17.
//  Copyright © 2017 Srobinson1. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var beginButton: UIButton!
    
    var gameSceneObject = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    @IBAction func beginButtonPressed(_ sender: Any)
    {
        
        gameSceneObject.makeBall()
        beginButton.isHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
