// Custom enemy classes
// by Jian Hong Mei 11/26/24

class Enemy: SKSpriteNode, NSCoding {
    var maxHealth: Int
    var currentHealth: Int
    var attackDamage: Int
    var attackCooldown: TimeInterval
    
    init(texture: SKTexture?, maxHealth: Int, attackDamage: Int, attackCooldown: TimeInterval, position: CGPoint, scale: CGFloat = 1.0) {
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.attackDamage = attackDamage
        self.attackCooldown = attackCooldown
        super.init(texture: texture, color: .clear, size: texture?.size() ?? CGSize(width: 50, height: 50))
        self.position = position
        self.name = "enemy"
        self.zPosition = 2
        self.setScale(scale)
    }
    
    // Default implementation for loading from NSCoder
    required init?(coder aDecoder: NSCoder) {
        // Decode saved values
        self.maxHealth = aDecoder.decodeInteger(forKey: "maxHealth")
        self.currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        self.attackDamage = aDecoder.decodeInteger(forKey: "attackDamage")
        self.attackCooldown = aDecoder.decodeDouble(forKey: "attackCooldown")
        self.setScale(aDecoder.decodeCGFloat(forKey: "scale")) // Restore scale when unarchiving
        super.init(coder: aDecoder)
        
    }
    
    // saving to NSCoder (for save/load system)
    func encode(with aCoder: NSCoder) {
        // Encode properties to be saved
        aCoder.encode(maxHealth, forKey: "maxHealth")
        aCoder.encode(currentHealth, forKey: "currentHealth")
        aCoder.encode(attackDamage, forKey: "attackDamage")
        aCoder.encode(attackCooldown, forKey: "attackCooldown") 
        aCoder.encode(self.xScale, forKey: "scale")
        super.encode(with: aCoder)
    }
}
