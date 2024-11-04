//
//  StartMenuScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 11/5/24.
//

import SpriteKit

class StartMenuScene: SKScene {

    override func didMove(to view: SKView) {
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Defend Your Castle")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .yellow
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        // Create and add the start button
        let startButton = SKLabelNode(text: "Start")
        startButton.fontSize = 45
        startButton.fontColor = .white
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startButton.name = "startButton"
        startButton.zPosition = 1
        self.addChild(startButton)
        
        // Create and add the settings button
        let settingsButton = SKLabelNode(text: "Settings")
        settingsButton.fontSize = 45
        settingsButton.fontColor = .white
        settingsButton.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.3)
        settingsButton.name = "settingsButton"
        settingsButton.zPosition = 1
        self.addChild(settingsButton)
        
        // Create and add the exit button
        let exitButton = SKLabelNode(text: "Exit")
        exitButton.fontSize = 45
        exitButton.fontColor = .white
        exitButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.1)
        exitButton.name = "exitButton"
        exitButton.zPosition = 1
        self.addChild(exitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "startButton" {
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(gameScene, transition: transition)
            }else if nodeTouched.name == "settingsButton"{
                
            }
            else if nodeTouched.name == "exitButton" {
                exit(0)
            }
        }
    }
}
