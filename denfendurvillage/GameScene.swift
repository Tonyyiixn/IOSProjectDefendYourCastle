//  GameScene.swift
//  DefendYourCastle
//
//  Created by Yixin Chen on 10/12/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameIsPaused = false
    static var currentGameScene: GameScene?
    var enemieslist = [ZombieSpriteNode]()
    var currentenemy:ZombieSpriteNode?
    var enemeyspeed:CGFloat = 0.0
    var castleHealth:CGFloat = 1.0 // Castle Health are set to 100%, castle health will double each times when the level upgrades
    var healthBarBackground:SKSpriteNode!
    var healthBarForeground:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var score: Int = 0
    var goal: Int = 10
    override func didMove(to view: SKView) {
        GameScene.currentGameScene = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleResumeGame), name: NSNotification.Name("ResumeGame"), object: nil)
            //Add the pause button
        let pausebutton = SKLabelNode(text: "pause")
        pausebutton.setScale(1)
        pausebutton.position = CGPoint(x: self.size.width*0.1, y: self.size.height * 0.9)
        pausebutton.name = "pauseGame"
        pausebutton.fontColor = .black
        pausebutton.zPosition = 1
        self.addChild(pausebutton)
        
        //Add the score to win
        scoreLabel = SKLabelNode(text: "score:\(score)")
        scoreLabel.setScale(1)
        scoreLabel.position = CGPoint(x: self.size.width*0.7, y: self.size.height * 0.9)
        scoreLabel.name = "pauseGame"
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)

        //Health bar background
        healthBarBackground = SKSpriteNode(color: .darkGray, size: CGSize(width:self.size.width*0.4,height:30))
        healthBarBackground.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        healthBarBackground.zPosition = 1
        self.addChild(healthBarBackground)
        
        //Health bar background
        healthBarForeground = SKSpriteNode(color: .red, size: CGSize(width:self.size.width*0.4,height:30))
        healthBarForeground.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthBarForeground.position = CGPoint(x: healthBarBackground.position.x - healthBarBackground.size.width / 2, y: healthBarBackground.position.y)
        healthBarForeground.zPosition = 2
        self.addChild(healthBarForeground)
        
            // Add the background
            let background = SKSpriteNode(imageNamed: "Background")
            background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            // Set background color to test visibility
            self.backgroundColor = .black
            
        
        self.startSpawningEnemies()
        addBuildingToScene(imageName: "Fortress Square")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)
            
            if nodeTouched.name == "pauseGame" {
                gameIsPaused = true
                let pauseScene = PauseMenuScene(size:self.size)
                pauseScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(pauseScene,transition: transition)
            }else if nodeTouched.name == "enemy" {
                if !gameIsPaused {
                    currentenemy = nodeTouched as? ZombieSpriteNode
                    currentenemy?.removeAllActions()
                }
            }
        }
    }
    
    @objc func handleResumeGame() {
        gameIsPaused = false
        
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            if let currentenemy = currentenemy {
                let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
                let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
                
                // Update enemy's position by adding the amount dragged to its current position
                currentenemy.position.x += amountDraggedX
                currentenemy.position.y += amountDraggedY
                
                // If the enemy is lifted above the ground, trigger falling animation
                            if currentenemy.position.y > self.size.height * 0.4 {
                                currentenemy.startFallingAnimation()
                            }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentenemy = currentenemy {
                // Start the falling animation
                 currentenemy.startFallingAnimation()
                 
                 // Fall action: Move the enemy to the ground level
                 let fallAction = SKAction.move(to: CGPoint(x: currentenemy.position.x, y: self.size.height * 0.4), duration: 1.5)
                 
                 // After falling is done, play the stumble animation
                 let stumbleAction = SKAction.run {
                     currentenemy.startStumbleAnimation()
                     self.dealDamageToZombie(zombie: currentenemy, damage: 0.5)
                 }
            
            
                             
                 // Combine fall and stumble actions into a sequence
            let sequence = SKAction.sequence([fallAction, stumbleAction])
                 
                 // Run the sequence (falling first, then stumbling)
                 currentenemy.run(sequence)
        }
        currentenemy = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameIsPaused {
                    // Prevent all actions from progressing while the game is paused
                    self.removeAllActions()
                    for enemy in enemieslist {
                        enemy.removeAllActions()
                    }
            scoreLabel.text = ""
                    return
                }
                
                if currentenemy == nil {
                    Enemymove()
                }
    }
    
    func Enemymove() {
        let leftTargetX = self.size.width * 0.40
        let rightTargetX = self.size.width * 0.60
        let speed: CGFloat = 0.2 // Adjust speed as needed
        
        for enemy in enemieslist {
            // Determine the target x-position
            let targetX = enemy.position.x < self.size.width * 0.5 ? leftTargetX : rightTargetX
            
            // Move the enemy towards the target x-position
            moveEnemyHorizontally(enemy: enemy, targetX: targetX, speed: speed)
            
            // Start the walking animation if it isn't already running
            if !enemy.hasActions() {
                enemy.startWalkingAnimation()
            }
            
            if abs(enemy.position.x - targetX) < 2 {
                            enemy.startAttackAnimation() // Start attack animation once the enemy reaches the target
                            dealDamageToCastle(damage: enemy.attackPoints)
                    }
        }
    }

    
    func spawnEnemy(){
        if gameIsPaused { return }
            
            let zombie = ZombieSpriteNode(size: CGSize(width: 100, height: 100))
            let startPointLeft = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.4)
            let startPointRight = CGPoint(x: self.size.width * 0.9, y: self.size.height * 0.4)
            let isLeftSide = Int.random(in: 1...2) == 1
            
            // Set the position and orientation based on spawn side
            zombie.position = isLeftSide ? startPointLeft : startPointRight
            zombie.xScale = isLeftSide ? -1.0 : 1.0 // Face right if on the left, flip if on the right
            zombie.name = "enemy"
            zombie.zPosition = 2
            self.addChild(zombie)

            enemieslist.append(zombie)

            // Start the walking animation
            zombie.startWalkingAnimation()
    }
 
    func moveEnemyHorizontally(enemy: ZombieSpriteNode, targetX: CGFloat, speed: CGFloat) {
        // Calculate the horizontal distance to the target
        let distanceX = targetX - enemy.position.x
        
        // If the enemy is close enough to the target, stop
        if abs(distanceX) < speed {
            enemy.position.x = targetX
            return
        }
        
        // Determine the direction (-1 for left, 1 for right)
        let direction = distanceX > 0 ? 1 : -1
        
        // Update the enemy's position based on the speed and direction
        enemy.position.x += CGFloat(direction) * speed
    }


    func startSpawningEnemies() {
            let spawnAction = SKAction.run(spawnEnemy)
            let waitAction = SKAction.wait(forDuration: 6.0, withRange: 0)
            let sequence = SKAction.sequence([spawnAction, waitAction])
            let repeatAction = SKAction.repeatForever(sequence)
            self.run(repeatAction)
        }
    
    func addBuildingToScene(imageName: String) {
            let building = SKSpriteNode(imageNamed: imageName)
        building.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
            building.setScale(0.4)
            building.zPosition = 1
            self.addChild(building)
        }
   
    func transitionToNextLevel(levelNumber: Int) {
        //addBuildingToScene(imageName: "Fortress Square Full")
        // Create a new instance of LevelScene and pass the next level number
        let nextLevelScene = LevelScene(size: self.size)
        nextLevelScene.levelNumber = levelNumber + 1 // Increment the level number for the next scene
        nextLevelScene.scaleMode = .aspectFill
        self.view?.presentScene(nextLevelScene, transition: SKTransition.fade(withDuration: 1.0))
        //every time the level rise, the speed of enimes and hitpoints would increase.
        //speed += 0.1
        //also, the castle would have more armor.
        //castleHealth *= 1.5
        //updateCastleHealthBar()
    }
    
    func checkAndTransitionToNextLevel() {
        if score >= goal {
            // Transition to the next level scene
            transitionToNextLevel(levelNumber: 1)
        }
    }
    
    func updateCastleHealthBar() {
        let healthPercentage = castleHealth
        healthBarForeground.size.width = CGFloat(healthPercentage) * healthBarBackground.size.width
    }

    func dealDamageToZombie(zombie: ZombieSpriteNode, damage: CGFloat) {
        zombie.hitpoints -= damage
        if zombie.hitpoints <= 0 {
            zombie.startDeathAnimation()
            zombie.removeFromParent()
            score += 1
            scoreLabel.text = "score:\(score)"
            if let index = enemieslist.firstIndex(of: zombie) {
                enemieslist.remove(at: index)
            }
            checkAndTransitionToNextLevel()
        }
    }
    
    func dealDamageToCastle(damage: CGFloat) {
        castleHealth -= damage
        if castleHealth <= 0 {
            transitionToGameOver()
        }
        updateCastleHealthBar()
    }
    
    func transitionToGameOver() {
        let gameOverScene = GameOverScene(size: size)
        view?.presentScene(gameOverScene)
    }
}

