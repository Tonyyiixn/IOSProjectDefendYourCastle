import SpriteKit

class ZombieSpriteNode: SKSpriteNode {
    // Animation frames
    var walkingFrames: [SKTexture] = []
    var attackFrames: [SKTexture] = []
    var deathFrames: [SKTexture] = []
    var stumbleFrames: [SKTexture] = []
    var fallingFrames: [SKTexture] = []
    var transitionFrames: [SKTexture] = []

    // Initialize the zombie
    init(size: CGSize) {
        // Load the first texture for initialization
        let initialTexture = SKTexture(imageNamed: "Zombie RL 1") // First walking frame
        super.init(texture: initialTexture, color: .clear, size: size)
        
        // Load animation frames
        loadAnimationFrames()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadAnimationFrames() {
        // Walking frames
        walkingFrames = (1...8).map { SKTexture(imageNamed: "Zombie RL \($0)") }
        
        // Attack frames
        attackFrames = (1...7).map { SKTexture(imageNamed: "attack\($0)") }
        
        // Death frames
        deathFrames = (1...16).map { SKTexture(imageNamed: "death\($0)") }
        
        // Falling frames
        fallingFrames = (1...2).map { SKTexture(imageNamed: "falling\($0)") }
        
        //Stumble frames
        stumbleFrames = (4...22).map { SKTexture(imageNamed: "falling\($0)") }
        
        // Transition frames
        transitionFrames = (1...5).map { SKTexture(imageNamed: "transition\($0)") }
    }
}

extension ZombieSpriteNode {
    // Play the walking animation
    func startWalkingAnimation() {
        let walkAnimation = SKAction.animate(with: walkingFrames, timePerFrame: 0.1)
        let repeatWalk = SKAction.repeatForever(walkAnimation)
        self.run(repeatWalk)
    }

    // Play the attack animation
    func startAttackAnimation() {
        let attackAnimation = SKAction.animate(with: attackFrames, timePerFrame: 0.15)
        let repeatAttack = SKAction.repeatForever(attackAnimation)
        self.run(repeatAttack)
    }

    // Play the death animation
    func startDeathAnimation() {
        let deathAnimation = SKAction.animate(with: deathFrames, timePerFrame: 0.1)
        let removeAfterDeath = SKAction.sequence([deathAnimation, .removeFromParent()])
        self.run(removeAfterDeath)
    }

    // Play the falling animation
    func startFallingAnimation() {
        let fallingAnimation = SKAction.animate(with: fallingFrames, timePerFrame: 0.1)
        self.run(fallingAnimation)
    }
    
    // Play the stumble animation
    func startStumbleAnimation() {
        let stubmbleAnimation = SKAction.animate(with: stumbleFrames, timePerFrame: 0.3)
        self.run(stubmbleAnimation)
    }
    
    // Play the transition animation
    func startTransitionAnimation() {
        let transitionAnimation = SKAction.animate(with: transitionFrames, timePerFrame: 0.1)
        self.run(transitionAnimation)
    }
}



