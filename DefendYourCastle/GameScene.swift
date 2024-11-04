//
//  GameScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/12/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let eneimes = SKSpriteNode(imageNamed: "placeholder")

    override func didMove(to view: SKView) {
            // Add the background
            let background = SKSpriteNode(imageNamed: "FloorCity")
            background.size = self.size
            background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            background.zPosition = 0
            self.addChild(background)
            
            // Set background color to test visibility
            self.backgroundColor = .black
            
            // Add the enemy sprite
        eneimes.setScale(0.2) // Set default scale to ensure visibility
        eneimes.position = CGPoint(x: self.size.width*0.2, y: self.size.height * 0.3) // Adjust position
            eneimes.zPosition = 2
            self.addChild(eneimes)
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            
            // Update enemy's position by adding the amount dragged to its current position
            eneimes.position.x += amountDraggedX
            eneimes.position.y += amountDraggedY
        }
    }

}
