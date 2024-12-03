//
//  GameOverScene.swift
//  denfendurvillage
//
//  Created by Yixin Chen on 12/3/24.
//


import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        // Create and add the game title
        let gameTitle = SKLabelNode(text: "Game Over! Want To Play Again?")
        gameTitle.fontSize = 60
        gameTitle.fontColor = .yellow
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.80)
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
                let upgradeScene = UpgradeMenuScene(size: self.size)
                upgradeScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(upgradeScene, transition: transition)
            }
            else if nodeTouched.name == "Back" {
                let BackScene = StartMenuScene(size: self.size)
                BackScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(BackScene, transition: transition)
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


