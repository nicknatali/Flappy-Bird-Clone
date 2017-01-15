//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Nick Natali on 1/12/17.
//  Copyright © 2017 Make It Appen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //The thing we would like to move or be animated
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    
    
    
    //Enum- grouping different types of objects together
    enum ColliderType: UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    var gameOver = false
    var scoreLabel = SKLabelNode()
    var score = 0
    var gameOverLabel = SKLabelNode()
    var timer = Timer()
    
    
    
    
        func makePipes() {
            //Illusion of pipes moving across screen
            let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width , dy: 0), duration: TimeInterval(self.frame.width / 100))
            
            
            //Gap height in between pipes
            let gapHeight = bird.size.height * 4
            
            //Total amount that a pipe's height will move up or down
            let movementAmount = arc4random() % UInt32( self.frame.height / 2 )
            
            //To not allow it to always move in one direction
            let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
            
            //Create pipe
            let pipeTexture = SKTexture(imageNamed: "pipe1.png")
            
            let pipe1 = SKSpriteNode(texture: pipeTexture)
            
            //Position in the center of the screen
            pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
            
            pipe1.run(movePipes)
            
            pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
            pipe1.physicsBody?.isDynamic = false
            
            //Can only detect contact between objects with the same contact Bit mask
            pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
            
            //Category that the node falls into
            pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
            
            //Collision bit mask makes it clear whether nodes can go into each other or not
            pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
            
            pipe1.zPosition = -1
            
            //Pipe it up
            self.addChild(pipe1)
            
            //Create pipe
            let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
            
            let pipe2 = SKSpriteNode(texture: pipe2Texture)
            
            //Position in the center of the screen
            pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture.size().height / 2 - gapHeight / 2 + pipeOffset)
            
            pipe2.run(movePipes)
            
            pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
            pipe2.physicsBody?.isDynamic = false
            
            //Can only detect contact between objects with the same contact Bit mask
                pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
            
            //Category that the node falls into
                pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
            
            //Collision bit mask makes it clear whether nodes can go into each other or not
                pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
            
            pipe2.zPosition = -1
        
            //Pipe it up
            self.addChild(pipe2)
            
            
            //Create gap between pipes to keep score
            let gap = SKNode()
            
            gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
            
            gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width , height: gapHeight))
            
            //Not affected by gravity
            gap.physicsBody!.isDynamic = false
            
            gap.run(movePipes)
            
            
            //Detect contact between the gap and the bird.
            gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
            
            //Category that the node falls into
            gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
            
            //Collision bit mask makes it clear whether nodes can go into each other or not
            gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
            
            self.addChild(gap)
            
            
        
        }
    
    //Is called when there is contact between two objects
    func didBegin(_ contact: SKPhysicsContact) {
    
    if gameOver == false {
        //Check if it came into contact with the gap
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score += 1
            
            scoreLabel.text = String(score)
            
        } else {
        
        
        print("we have contact")
        
        //Stop everything
            self.speed = 0
        
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 30
            
            gameOverLabel.text = "Game Over. Tap to play again!"
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
            
            }
        }
        
    }
    
    
    func setUpGame() {
        //Timer
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        //Add to view controller
        self.addChild(bird)
        
        //Create Background Texture
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        //Move the background one pixel to the left every .1 seconds
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 5)
        //Once a whole length of a background has gone by it resets it to the right
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        
        
        //Repeat animation forever
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            
            bg = SKSpriteNode(texture: bgTexture)
            
            //Center background on screen
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            
            //Make it the same height as the screen
            bg.size.height = self.frame.height
            
            //Animate background
            bg.run(moveBGForever)
            
            //Add background to screen
            self.addChild(bg)
            
            i += 1
            
            //Ensure that the background goes behind the bird- zPosition is a position perpindicular to the screen - higher number goes in front.
            
            bg.zPosition = -2
            
            
        }
        
        //Create bird
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        //SKAction is generally an animation or movement
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        
        //Make bird flap forever
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        
        //Position in the center of the screen
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //apply animation to bird
        bird.run(makeBirdFlap)
        
        //Gravity affect- tells where the bird is by putting a circle around it
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        //Start gravity upon first touch - false
        bird.physicsBody!.isDynamic = false
        
        
        //Create groups
        //Can only detect contact between objects with the same contact Bit mask
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        //Category that the node falls into
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        
        //Collision bit mask makes it clear whether nodes can go into each other or not
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        //Add to screen
        self.addChild(bird)
        
        
        //Create Ground for the bird to hit
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        //Height of 1 to create an invisible barrier to stop the bird from falling through the screen
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        //Ground is not movin'
        ground.physicsBody!.isDynamic = false
        
        //Can only detect contact between objects with the same contact Bit mask
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        //Category that the node falls into
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        //Collision bit mask makes it clear whether nodes can go into each other or not
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        //Add the ground to the screen
        self.addChild(ground)
        
        //Customize the score label
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 60
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
    }
    
    
    
        override func didMove(to view: SKView) {
            
            self.physicsWorld.contactDelegate = self
            setUpGame()
            
            }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        
        //let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        //Start gravity upon first touch - true
        bird.physicsBody!.isDynamic = true
        
        //Set velocity of bird- so it falls a little slower
        bird.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
        
    //Ball with a bat- propels it into opposite direction 50 pixels
        bird.physicsBody!.applyImpulse(CGVector(dx:0, dy: 50))
            
        } else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setUpGame()
            
        }
        
        
      
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
