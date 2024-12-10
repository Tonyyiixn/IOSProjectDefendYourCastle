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
    var goal: Int = 5  // Changed from 10 to 5
    var points: Int = 0
    var pointsLabel: SKLabelNode!
    var lastHealthCheck: CGFloat = 1.0
    var levelNumber: Int = 1
    var spawnInterval: TimeInterval = 6.0
    var levelLabel: SKLabelNode!
    static var highestLevel: Int = 1
    var baseEnemySpeed: CGFloat = 0.2  // Initial speed
    var currentEnemySpeed: CGFloat = 0.2  // Current speed that will increase with levels

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
        scoreLabel = SKLabelNode(text: "Score:\(score)")
        scoreLabel.setScale(1)
        scoreLabel.position = CGPoint(x: self.size.width*0.36, y: self.size.height * 0.78)
        scoreLabel.name = "pauseGame"
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // Initialize points label
        setupPointsLabel()
        setupLevelLabel()
        
        //Health bar background
        healthBarBackground = SKSpriteNode(color: .darkGray, size: CGSize(width:self.size.width*0.4,height:30))
        healthBarBackground.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.9)
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
        
        // Reset enemy speed based on current level
        currentEnemySpeed = baseEnemySpeed * (1 + CGFloat(levelNumber - 1) * 0.2)
        
        self.startSpawningEnemies()
        addBuildingToScene(imageName: "Fortress Square")
    }
    
    func setupPointsLabel() {
        // Remove existing points label if it exists
        pointsLabel?.removeFromParent()
        
        pointsLabel = SKLabelNode(text: "Points: \(points)")
        pointsLabel.setScale(1)
        pointsLabel.position = CGPoint(x: self.size.width*0.9, y: self.size.height * 0.85)
        pointsLabel.fontColor = .black
        pointsLabel.zPosition = 1
        self.addChild(pointsLabel)
    }

    func setupLevelLabel() {
        // Remove existing level label if it exists
        levelLabel?.removeFromParent()
        
        levelLabel = SKLabelNode(text: "Level: \(levelNumber)")
        levelLabel.setScale(1)
        levelLabel.position = CGPoint(x: self.size.width*0.9, y: self.size.height * 0.92)
        levelLabel.fontColor = .black
        levelLabel.zPosition = 1
        self.addChild(levelLabel)
    }

    
    func updatePoints(amount: Int) {
        points += amount
        // Make sure we're updating the correct label
        if let label = pointsLabel {
            label.text = "Points: \(points)"
        }
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
        pointsLabel.text = "Points: \(points)"
        levelLabel.text = "Level: \(levelNumber)"
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
                
                // If the enemy is dragged high enough, signal falling death animation
                if currentenemy.position.y > self.size.height * 0.7 {
                    handleZombieDrop(zombie: currentenemy)
                    self.currentenemy = nil // Reset currentenemy after handling drop
                }
            }
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentenemy = currentenemy {
            // If touchesEnded is triggered, signal the stumble animation
            currentenemy.startStumbleAnimation()
            self.currentenemy = nil // Reset currentenemy after stumble animation
        }
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
        let speed: CGFloat = currentEnemySpeed
        
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

    
    func spawnEnemy() {
        if gameIsPaused { return }
            
        let zombie = ZombieSpriteNode(size: CGSize(width: 100, height: 100))
        // Move spawn points off screen (using negative x for left side and size.width + buffer for right side)
        let startPointLeft = CGPoint(x: -50, y: self.size.height * 0.4)  // 50 pixels left of screen
        let startPointRight = CGPoint(x: self.size.width + 50, y: self.size.height * 0.4)  // 50 pixels right of screen
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
        // Remove any existing spawn actions
        self.removeAction(forKey: "spawnEnemies")
        
        let spawnAction = SKAction.run(spawnEnemy)
        let waitAction = SKAction.wait(forDuration: spawnInterval, withRange: 0)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        self.run(repeatAction, withKey: "spawnEnemies")
    }
    
    func addBuildingToScene(imageName: String) {
            let building = SKSpriteNode(imageNamed: imageName)
        building.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
            building.setScale(0.4)
            building.zPosition = 1
            self.addChild(building)
        }
   
    func transitionToNextLevel(levelNumber: Int) {
        increaseEnemySpeed()  // Increase speed before transitioning
        let nextLevelScene = LevelScene(size: self.size)
        nextLevelScene.levelNumber = levelNumber + 1
        nextLevelScene.currentPoints = points  // Pass the current points to the next level
        nextLevelScene.scaleMode = .aspectFill
        self.view?.presentScene(nextLevelScene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    func checkAndTransitionToNextLevel() {
        if score >= goal {
            transitionToNextLevel(levelNumber: levelNumber)
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
        if (lastHealthCheck - castleHealth) >= 0.2 {
            lastHealthCheck = castleHealth
            NotificationCenter.default.post(name: NSNotification.Name("ArcherKilled"), object: nil)
        }
        updateCastleHealthBar()
    }
    
    func transitionToGameOver() {
        // Update highest level if current level is higher
        if levelNumber > GameScene.highestLevel {
            GameScene.highestLevel = levelNumber
        }
        
        // Present game over scene
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.finalLevel = levelNumber  // Pass the current level
        gameOverScene.highestLevel = GameScene.highestLevel  // Pass the highest level
        view?.presentScene(gameOverScene)
    }
    
    func handleZombieDrop(zombie: ZombieSpriteNode) {
        let groundLevel = self.size.height * 0.4
        let fallDistance = zombie.position.y - groundLevel
        let fallDuration = TimeInterval(fallDistance / 100) // Adjust for desired speed
        
        // Start the falling animation
        zombie.startFallingAnimation()
        
        // Create the fall action
        let fallAction = SKAction.moveTo(y: groundLevel, duration: fallDuration)
        
        // Run the death animation and remove the zombie
        let deathAction = SKAction.run { zombie.startDeathAnimation() }
        let removeAction = SKAction.run {
            zombie.removeFromParent()
            if let index = self.enemieslist.firstIndex(of: zombie) {
                self.enemieslist.remove(at: index)
            }
            self.score += 1
            self.updatePoints(amount: 1)
            self.scoreLabel.text = "score:\(self.score)"
            self.checkAndTransitionToNextLevel()
        }
        
        // Combine actions into a sequence
        let sequence = SKAction.sequence([fallAction, deathAction, SKAction.wait(forDuration: 1.6), removeAction])
        zombie.run(sequence)
    }

    func increaseEnemySpeed() {
        // Increase speed by 10% each level
        currentEnemySpeed = baseEnemySpeed * (1 + CGFloat(levelNumber - 1) * 0.2)
    }

               
    
}

