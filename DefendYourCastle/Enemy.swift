// Custom enemy classes
// by Jian Hong Mei 11/26/24

import SpriteKit

class Enemy: SKSpriteNode{
    var maxHealth: Int
    var currentHealth: Int
    var attackDamage: Int
    var attackCooldown: TimeInterval
    var imageName: String

    init(
        texture: SKTexture?,
        imageName: String = "placeholder", // default image name
        name: String = "enemy",
        maxHealth: Int,
        attackDamage: Int,
        attackCooldown: TimeInterval,
        position: CGPoint,
        scale: CGFloat = 1.0
    ){
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.attackDamage = attackDamage
        self.attackCooldown = attackCooldown
        self.imageName = imageName
        super.init(texture: texture, color: .clear, size: texture?.size() ?? CGSize(width: 50, height: 50))
        self.position = position
        self.name = name
        self.zPosition = 2
        self.setScale(scale)
    }

    // Take damage function
    func takeDamage(_ damage: Int){
        // Reduce current health by damage amount
        currentHealth -= damage
            
        // handle death (e.g., remove from scene or trigger death animation)
        if currentHealth < 0{
            handleDeath()
        }
    }

    // Handle the enemy's death
    func handleDeath(){
        // To be implemented - handling enemy death (removing from scene, playing death animation, etc.)
        self.removeFromParent() // Removes the enemy from the scene
    }
    
    // NSCoder - load system
    required init?(coder aDecoder: NSCoder){
        guard
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let imageName = aDecoder.decodeObject(forKey: "imageName") as? String
        else {return nil}
        
        let texture = SKTexture(imageNamed: imageName) // Create the texture from the image name
        
        let maxHealth = aDecoder.decodeInteger(forKey: "maxHealth")
        let attackDamage = aDecoder.decodeInteger(forKey: "attackDamage")
        let attackCooldown = aDecoder.decodeDouble(forKey: "attackCooldown")
        let positionX = aDecoder.decodeDouble(forKey: "positionX")
        let positionY = aDecoder.decodeDouble(forKey: "positionY")
        let scale = aDecoder.decodeDouble(forKey: "scale")
        let currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        self.maxHealth = maxHealth
        self.currentHealth = currentHealth
        self.attackDamage = attackDamage
        self.attackCooldown = attackCooldown
        self.imageName = imageName
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = name
        self.position = CGPoint(x: positionX, y: positionY)
        self.setScale(CGFloat(scale))
    }

    // save system
    override func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(currentHealth, forKey: "currentHealth")
        aCoder.encode(maxHealth, forKey: "maxHealth")
        aCoder.encode(attackDamage, forKey: "attackDamage")
        aCoder.encode(attackCooldown, forKey: "attackCooldown")
        aCoder.encode(position.x, forKey: "positionX")
        aCoder.encode(position.y, forKey: "positionY")
        aCoder.encode(self.xScale, forKey: "scale")
    }
}
