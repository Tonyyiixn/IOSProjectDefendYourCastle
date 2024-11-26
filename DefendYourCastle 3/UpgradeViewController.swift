//
//  UpgradeViewController.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 11/25/24.
//

import UIKit
import SpriteKit

class UpgradeViewController: UIViewController {
    var gameScene: GameScene?
       var skView: SKView?

       override func viewDidLoad() {
           super.viewDidLoad()

           skView = SKView(frame: self.view.bounds)
           skView?.backgroundColor = .black
           self.view.addSubview(skView!)

           let upgradeMenuScene = UpgradeMenuScene(size: skView!.bounds.size)
           upgradeMenuScene.scaleMode = .aspectFill
           skView?.presentScene(upgradeMenuScene)

       }
}
