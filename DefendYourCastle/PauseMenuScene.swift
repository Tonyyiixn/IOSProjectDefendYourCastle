//
//  PauseMenuScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 11/5/24.
//

import SpriteKit

class PauseMenuScene: SKScene {

    override func didMove(to view: SKView) {
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Paused")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .red
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        // Create and add the start button
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.fontSize = 45
        restartButton.fontColor = .white
        restartButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        restartButton.name = "restart"
        restartButton.zPosition = 1
        self.addChild(restartButton)
        
        // Create and add the upgrade button
        let upgradeButton = SKLabelNode(text: "Upgrade")
        upgradeButton.fontSize = 45
        upgradeButton.fontColor = .white
        upgradeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.3)
        upgradeButton.name = "upgradesystem"
        upgradeButton.zPosition = 1
        self.addChild(upgradeButton)
        
        // Create and add the exit button
        let backButton = SKLabelNode(text: "Back To Main Menu")
        backButton.fontSize = 45
        backButton.fontColor = .white
        backButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.1)
        backButton.name = "Back"
        backButton.zPosition = 1
        self.addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "restart" {
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(gameScene, transition: transition)
            }else if nodeTouched.name == "upgradesystem"{
                
            }
            else if nodeTouched.name == "Back" {
                let BackScene = StartMenuScene(size: self.size)
                BackScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(BackScene, transition: transition)

            }
        }
    }
}
