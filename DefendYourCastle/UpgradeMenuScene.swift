//
//  UpgradeMenuScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 11/25/24.
//

import SpriteKit
import AVFoundation

class UpgradeMenuScene: SKScene {
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        playBgAudio(fileNamed: "hbg.mp3")
        if let viewController = view.window?.rootViewController as? GameViewController {
                    gameViewController = viewController
                }
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Upgrade System")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .yellow
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.80)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        // Create and add the start button
        let startButton = SKLabelNode(text: "Add Square")
        startButton.fontSize = 45
        startButton.fontColor = .white
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        startButton.name = "Square"
        startButton.zPosition = 1
        self.addChild(startButton)
        
        // Create and add the upgrade button
        let upgradeButton = SKLabelNode(text: "Add Back towers")
        upgradeButton.fontSize = 45
        upgradeButton.fontColor = .white
        upgradeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.40)
        upgradeButton.name = "Backtowers"
        upgradeButton.zPosition = 1
        self.addChild(upgradeButton)
        
        // Create and add the settings button
        let settingsButton = SKLabelNode(text: "build front towers")
        settingsButton.fontSize = 45
        settingsButton.fontColor = .white
        settingsButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.20)
        settingsButton.name = "Fronttowers"
        settingsButton.zPosition = 1
        self.addChild(settingsButton)
        
        
        // Create and add the exit button
        let exitButton = SKLabelNode(text: "Back To Main Menu")
        exitButton.fontSize = 45
        exitButton.fontColor = .white
        exitButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0)
        exitButton.name = "Back"
        exitButton.zPosition = 1
        self.addChild(exitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "Square" {
                gameViewController?.gameScene?.addBuildingToScene(imageName: "Fortress Square")
            }else if nodeTouched.name == "Backtowers"{
                gameViewController?.gameScene?.addBuildingToScene(imageName: "Fortress Square With Back Towers")
            }else if nodeTouched.name == "Fronttowers"{
                gameViewController?.gameScene?.addBuildingToScene(imageName: "Front Towers")
            }
            else if nodeTouched.name == "Back" {
                let BackScene = StartMenuScene(size: self.size)
                BackScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(BackScene, transition: transition)
            }
        }
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


