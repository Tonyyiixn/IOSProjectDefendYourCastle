import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var enemieslist = [SKSpriteNode]()
    var currentenemy: SKSpriteNode?
    var enemeyspeed: CGFloat = 0.0

    override func didMove(to view: SKView) {
        // Add the pause button
        let pausebutton = SKLabelNode(text: "pause")
        pausebutton.setScale(1)
        pausebutton.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.9)
        pausebutton.name = "pauseGame"
        pausebutton.fontColor = .black
        pausebutton.zPosition = 1
        self.addChild(pausebutton)

        // Add the background
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)

        // Set background color to test visibility
        self.backgroundColor = .black

        startSpawningEnemies()
        addBuildingToScene(imageName: "Fortress Square")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = self.atPoint(location)

            if nodeTouched.name == "pauseGame" {
                let pauseScene = PauseMenuScene(size: self.size)
                pauseScene.scaleMode = .aspectFill

                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(pauseScene, transition: transition)
            } else if nodeTouched.name == "enemy" {
                currentenemy = nodeTouched as? SKSpriteNode
                currentenemy?.removeAllActions()
            }
        }
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
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentenemy = currentenemy {
            let fallAction = SKAction.move(to: CGPoint(x: currentenemy.position.x, y: self.size.height * 0.4), duration: 1.5)
            let targetX = currentenemy.position.x < self.size.width * 0.5 ? self.size.width * 0.40 : self.size.width * 0.6
            let moveAction = SKAction.moveTo(x: targetX, duration: 12.0)
            let sequence = SKAction.sequence([fallAction, moveAction])
            currentenemy.run(sequence)
        }
    }

    func Enemymove() {
        let enemymoveleft = SKAction.moveTo(x: self.size.width * 0.40, duration: 12.0)
        let enemymoveright = SKAction.moveTo(x: self.size.width * 0.60, duration: 12.0)
        for enemy in enemieslist {
            let enemymove = enemy.position.x < self.size.width * 0.5 ? enemymoveleft : enemymoveright
            enemy.run(enemymove)
        }
    }

    func spawnEnemy() {
        // Replace placeholder with ZombieSpriteNode
        let zombie = ZombieSpriteNode(size: CGSize(width: 100, height: 100))
        let startPointLeft = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.4)
        let startPointRight = CGPoint(x: self.size.width * 0.9, y: self.size.height * 0.4)

        zombie.position = Int.random(in: 1...2) == 1 ? startPointLeft : startPointRight
        zombie.name = "enemy"
        zombie.zPosition = 2
        self.addChild(zombie)

        enemieslist.append(zombie)

        zombie.startWalkingAnimation()
        Enemymove()
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
}
