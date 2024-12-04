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
        
        // Calculate even spacing
        let topMargin: CGFloat = 0.85  // Title position
        let bottomMargin: CGFloat = 0.15  // Space from bottom
        let numberOfButtons: CGFloat = 6  // Total number of buttons including title
        let spacing = (topMargin - bottomMargin) / (numberOfButtons - 1)
        
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Upgrade System")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .yellow
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * topMargin)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        // Add resume button
        let resumeButton = SKLabelNode(text: "Resume Game")
        resumeButton.fontSize = 45
        resumeButton.fontColor = .white
        resumeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * (topMargin - spacing))
        resumeButton.name = "resume"
        resumeButton.zPosition = 1
        self.addChild(resumeButton)
        
        // Create and add the square button
        let startButton = SKLabelNode(text: "Add Square")
        startButton.fontSize = 45
        startButton.fontColor = .white
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * (topMargin - spacing * 2))
        startButton.name = "Square"
        startButton.zPosition = 1
        self.addChild(startButton)
        
        // Create and add the back towers button
        let upgradeButton = SKLabelNode(text: "Add Back Towers")
        upgradeButton.fontSize = 45
        upgradeButton.fontColor = .white
        upgradeButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * (topMargin - spacing * 3))
        upgradeButton.name = "Backtowers"
        upgradeButton.zPosition = 1
        self.addChild(upgradeButton)
        
        // Create and add the front towers button
        let settingsButton = SKLabelNode(text: "Build Front Towers")
        settingsButton.fontSize = 45
        settingsButton.fontColor = .white
        settingsButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * (topMargin - spacing * 4))
        settingsButton.name = "Fronttowers"
        settingsButton.zPosition = 1
        self.addChild(settingsButton)
        
        // Create and add the exit button
        let exitButton = SKLabelNode(text: "Back To Main Menu")
        exitButton.fontSize = 45
        exitButton.fontColor = .white
        exitButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * (topMargin - spacing * 5))
        exitButton.name = "Back"
        exitButton.zPosition = 1
        self.addChild(exitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "resume" {
                NotificationCenter.default.post(name: NSNotification.Name("ResumeGame"), object: nil)
                if let gameScene = GameScene.currentGameScene {
                    let transition = SKTransition.reveal(with: .up, duration: 1.0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
            } else if nodeTouched.name == "Square" {
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




