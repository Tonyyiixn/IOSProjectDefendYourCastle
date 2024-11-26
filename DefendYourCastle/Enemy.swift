// Custom enemy classes
// by Jian Hong Mei 11/26/24

// Custom enemy classes
// by Jian Hong Mei 11/26/24

class Enemy: SKSpriteNode, NSCoding{
    var maxHealth: Int
    var currentHealth: Int
    var attackDamage: Int
    var attackCooldown: TimeInterval

    init(
        texture: SKTexture?,
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
        super.init(texture: texture, color: .clear, size: texture?.size() ?? CGSize(width: 50, height: 50))
        self.position = position
        self.name = name
        self.zPosition = 2
        self.setScale(scale)
    }

    // NSCoder initializer
    required init?(coder aDecoder: NSCoder){
        guard 
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let textureName = aDecoder.decodeObject(forKey: "textureName") as? String,
            let texture = SKTexture(imageNamed: textureName) else {return nil}
        let maxHealth = aDecoder.decodeInteger(forKey: "maxHealth")
        let attackDamage = aDecoder.decodeInteger(forKey: "attackDamage")
        let attackCooldown = aDecoder.decodeDouble(forKey: "attackCooldown")
        let positionX = aDecoder.decodeDouble(forKey: "positionX")
        let positionY = aDecoder.decodeDouble(forKey: "positionY")
        let scale = aDecoder.decodeDouble(forKey: "scale")

        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.attackDamage = attackDamage
        self.attackCooldown = attackCooldown
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = name
        self.position = CGPoint(x: positionX, y: positionY)
        self.setScale(CGFloat(scale))
    }

    // Encode to save system
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "name")
        aCoder.encode(maxHealth, forKey: "maxHealth")
        aCoder.encode(attackDamage, forKey: "attackDamage")
        aCoder.encode(attackCooldown, forKey: "attackCooldown")
        aCoder.encode(position.x, forKey: "positionX")
        aCoder.encode(position.y, forKey: "positionY")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(texture?.name, forKey: "textureName")
    }
}
