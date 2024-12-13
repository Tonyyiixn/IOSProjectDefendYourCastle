//
//  StartMenuScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 11/5/24.
//

import SpriteKit
import AVFoundation

class StartMenuScene: SKScene {
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        playBgAudio(fileNamed: "hbg.mp3")
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Defend Your Castle")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .yellow
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.80)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        // Create and add the start button
        let startButton = SKLabelNode(text: "Start")
        startButton.fontSize = 45
        startButton.fontColor = .white
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        startButton.name = "startButton"
        startButton.zPosition = 1
        self.addChild(startButton)
        
        // Create and add the upgrade button
//        let upgradeButton = SKLabelNode(text: "Upgrade")
//        upgradeButton.fontSize = 45
//        upgradeButton.fontColor = .white
//        upgradeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.40)
//        upgradeButton.name = "upgradesystem"
//        upgradeButton.zPosition = 1
//        self.addChild(upgradeButton)
        
        // Create and add the settings button
//        let settingsButton = SKLabelNode(text: "Settings")
//        settingsButton.fontSize = 45
//        settingsButton.fontColor = .white
//        settingsButton.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.20)
//        settingsButton.name = "settingsButton"
//        settingsButton.zPosition = 1
//        self.addChild(settingsButton)
        
        
        // Create and add the exit button
        let exitButton = SKLabelNode(text: "Exit")
        exitButton.fontSize = 45
        exitButton.fontColor = .white
        exitButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.4)
        exitButton.name = "exitButton"
        exitButton.zPosition = 1
        self.addChild(exitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "startButton" {
                // Transition to LevelScene
                let levelScene = LevelScene(size: self.size)
                levelScene.levelNumber = 1 // Start at Level 1
                levelScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(levelScene, transition: transition)
            } else if nodeTouched.name == "settingsButton" {
                // Handle settings button tap (add logic here)
            }
//            else if nodeTouched.name == "upgradesystem" {
//                // Transition to UpgradeMenuScene
//                let upgradeScene = UpgradeMenuScene(size: self.size)
//                upgradeScene.scaleMode = .aspectFill
//                let transition = SKTransition.fade(withDuration: 1.0)
//                self.view?.presentScene(upgradeScene, transition: transition)
//            }
            else if nodeTouched.name == "exitButton" {
                exit(0)
            }
        }
    }
    
    func addBuildingToScene(imageName: String) {
            let building = SKSpriteNode(imageNamed: imageName)
            building.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            building.zPosition = 1
            self.addChild(building)
        }
    
    //For Background music and sound effects
    var backGroundAudio = AVAudioPlayer()
    func playBgAudio (fileNamed: String){
        let url = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        guard let newURL = url else{
            print ("Cannot find file called \(fileNamed)")
            return
        }
        do {
            backGroundAudio = try AVAudioPlayer(contentsOf: newURL)
            backGroundAudio.numberOfLoops = -1
            backGroundAudio.prepareToPlay()
            backGroundAudio.play()
        }
        catch let error as NSError{
            print(error.description)
        }
    }
}


