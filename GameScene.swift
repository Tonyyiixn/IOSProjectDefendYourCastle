//  GameScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/12/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    //bit #s assigned to our objects
    struct Physicscategories{
        static let None : UInt32 = 0
        static let `Self` : UInt32 = 0b1 //1
        static let Enemies : UInt32 = 0b10 //2
    }
    
    let enemies = SKSpriteNode(imageNamed: "placeholder")
    var enemeyspeed:CGFloat = 0.0
    override func didMove(to view: SKView) {
            //Add the pause button
        let pausebutton = SKLabelNode(text: "pause")
        pausebutton.setScale(1)
        pausebutton.position = CGPoint(x: self.size.width*0.1, y: self.size.height * 0.9)
        pausebutton.name = "pauseGame"
        pausebutton.zPosition = 1
        self.addChild(pausebutton)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = Physicscategories.Self
        self.physicsBody!.collisionBitMask = Physicscategories.None //no collision but there will be contact
        self.physicsBody!.contactTestBitMask = Physicscategories.Enemies
        
            // Add the background
            let background = SKSpriteNode(imageNamed: "land")
            background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            // Set background color to test visibility
            self.backgroundColor = .black
            
            // Add the enemy sprite
            enemies.setScale(0.2) // Set default scale to ensure visibility
            enemies.position = CGPoint(x: self.size.width*0.2, y: self.size.height * 0.2)
        
            // Adjust position
            enemies.zPosition = 2
            enemies.name = "enemy"
            self.addChild(enemies)
            enemies.physicsBody = SKPhysicsBody(rectangleOf: self.size)
            enemies.physicsBody!.affectedByGravity = false
        enemies.physicsBody!.categoryBitMask = Physicscategories.Enemies
        enemies.physicsBody!.collisionBitMask = Physicscategories.None //no collision but there will be contact
        enemies.physicsBody!.contactTestBitMask = Physicscategories.Self //castle will be added in later
        
        
    }
    func didBeginContact(contact : SKPhysicsContact){
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        //contact made between self and enemy
        if body1.categoryBitMask == Physicscategories.Self && body2.categoryBitMask == Physicscategories.Enemies {
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
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
                enemies.removeAllActions()
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
            enemies.position.x += amountDraggedX
            enemies.position.y += amountDraggedY
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Enemymove()
    }
    func Enemymove(){
        let enemymove = SKAction.moveTo(x: self.size.width*0.4, duration: 6.0)
        enemies.run(enemymove)
    }
}
