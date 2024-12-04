//
//  LevelScene.swift
//  denfendurvillage
//
//  Created by Kyle Adjei on 12/2/24.
//


import SpriteKit

class LevelScene: SKScene {
    var levelNumber: Int = 1 
    var currentPoints: Int = 0
    
    override func didMove(to view: SKView) {
        // Set up the background
        self.backgroundColor = .black
        
        // Add "Level X" label
        let levelLabel = SKLabelNode(text: "Level \(levelNumber)")
        levelLabel.fontSize = 60
        levelLabel.fontColor = .white
        levelLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        levelLabel.zPosition = 1
        self.addChild(levelLabel)
        
        // Add fade-in and fade-out animation for the label
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let removeLabel = SKAction.removeFromParent()
        let labelSequence = SKAction.sequence([fadeIn, fadeOut, removeLabel])
        levelLabel.run(labelSequence)

        // Wait for 1.5 seconds before transitioning to the game scene
        let wait = SKAction.wait(forDuration: 1.5)
        let transitionToGame = SKAction.run { [weak self] in
            self?.startGameScene()
        }
        self.run(SKAction.sequence([wait, transitionToGame]))
    }

    func startGameScene() {
        let gameScene = GameScene(size: self.size)
        gameScene.levelNumber = levelNumber
        gameScene.goal = 5 + (levelNumber - 1) * 1
        gameScene.spawnInterval = max(1.0, 3.0 - Double(levelNumber - 1) * 0.5)
        gameScene.points = currentPoints
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
    }
}
