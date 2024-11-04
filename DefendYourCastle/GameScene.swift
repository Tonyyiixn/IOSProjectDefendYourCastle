//  GameScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/12/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let eneimes = SKSpriteNode(imageNamed: "placeholder")
    var enemeyspeed:CGFloat = 0.0
    override func didMove(to view: SKView) {
            //Add the pause button
        let pausebutton = SKLabelNode(text: "pause")
        pausebutton.setScale(1)
        pausebutton.position = CGPoint(x: self.size.width*0.1, y: self.size.height * 0.9)
        pausebutton.name = "pauseGame"
        pausebutton.zPosition = 1
        self.addChild(pausebutton)
        
            // Add the background
            let background = SKSpriteNode(imageNamed: "land")
            background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            // Set background color to test visibility
            self.backgroundColor = .black
            
            // Add the enemy sprite
            eneimes.setScale(0.2) // Set default scale to ensure visibility
            eneimes.position = CGPoint(x: self.size.width*0.2, y: self.size.height * 0.2)
            // Adjust position
            eneimes.zPosition = 2
            eneimes.name = "enemy"
            self.addChild(eneimes)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "pauseGame" {
                let pauseScene = PauseMenuScene(size:self.size)
                pauseScene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(pauseScene,transition: transition)
            }else if nodeTouched.name == "enemy" {
                eneimes.removeAllActions()
            }else{
                Enemymove()
            }
        }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Enemymove()
    }
    func Enemymove(){
        let enemymove = SKAction.moveTo(x: self.size.width*0.4, duration: 6.0)
        eneimes.run(enemymove)
    }
}
