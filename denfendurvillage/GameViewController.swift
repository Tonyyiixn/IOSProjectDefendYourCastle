//
//  GameViewController.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/12/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let landscapeSize = CGSize(width: 852, height: 393)
            let scene = StartMenuScene(size:landscapeSize)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    func presentUpgradeMenuScene() {
        if let view = self.view as! SKView? {
            let landscapeSize = CGSize(width: 852, height: 393)
            let upgradeMenuScene = UpgradeMenuScene(size: landscapeSize)
            upgradeMenuScene.scaleMode = .aspectFill
            view.presentScene(upgradeMenuScene)
            let currentScene = upgradeMenuScene
        }
    }
    
    func presentGameScene() {
        if let view = self.view as! SKView? {
            let landscapeSize = CGSize(width: 852, height: 393)
            let gameScene = GameScene(size: landscapeSize)
            gameScene.scaleMode = .aspectFill
            view.presentScene(gameScene)
            let currentScene = gameScene
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
