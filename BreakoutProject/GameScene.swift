//
//  GameScene.swift
//  BreakoutProject
//
//  Created by Srobinson1 on 3/16/17.
//  Copyright © 2017 Srobinson1. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    
    var paddle: SKSpriteNode!
    
    var brick: SKSpriteNode!
    
    let startLabel = SKLabelNode()
    
    var maxi = 3
    
    var bricksCount = 9
    
    var ballReset = true
    
    var viewControllerObject = GameViewController()
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        //Constraint around edge of view so that ball doesn't fall off of the screen
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createBackground()
        
        makePaddle()
        
        makeBall()
        
        makeBrick()
        
        makeLoseZone()
        
        startLabel.text = "Touch the Paddle to Start"
        startLabel.fontSize = 20
        startLabel.position = CGPoint(x: frame.midX, y: frame.midY+100)
        startLabel.fontColor = UIColor.white
        addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            paddle.position.x = location.x
        }
        if ballReset == true
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
            ballReset = false
        }
        startLabel.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            paddle.position.x = location.x
        }
        if ballReset == true
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
            ballReset = false
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        if contact.bodyA.node?.name == "brick"
        {
            print("brick hit")
            removeChildren(in: nodes(at: (contact.bodyA.node?.position)!))
            bricksCount -= 1
            checkBricks()
        }
        else if contact.bodyB.node?.name == "brick"
        {
            print("brick hit")
            removeChildren(in: nodes(at: (contact.bodyB.node?.position)!))
            bricksCount -= 1
            checkBricks()
        }
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("You Lose")
        }
    }
    
    func createBackground()
    {
        
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1
        {
            
            let starsBackground = SKSpriteNode(texture: stars)
            
            starsBackground.zPosition = -1
            
            //Anchor point means when you referance where the background is coming from
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1*i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            
            let moveLoop = SKAction.sequence([moveDown,moveReset])
            
            let moveForever = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(moveForever)
        }
        
    }
    
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        
        ball = SKSpriteNode(color: UIColor.green, size: CGSize(width: ballDiameter, height: ballDiameter))
        
        ball.position = CGPoint(x: frame.midX, y: frame.minY + 150)
        
        ball.name = "ball"
        
        //This adds a physics frame around the ball.
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        
        ball.physicsBody?.isDynamic = true
        
        //This is used for the square
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        ball.physicsBody?.friction = 0
        
        ball.physicsBody?.allowsRotation = false
        
        ball.physicsBody?.restitution = 1
        
        ball.physicsBody?.angularDamping = 0
        
        ball.physicsBody?.linearDamping = 0
        
        ball.physicsBody?.affectedByGravity = false
        
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
                
        addChild(ball)
        
    }
    
    
    
    func makePaddle()
    {
        
        paddle = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY+125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
        
    }
    
    
    func makeBrick()
    {
        for h in 1...maxi
        {
            let hh : CGFloat = CGFloat(h)
            for w in 1...maxi
            {
                let ww : CGFloat = CGFloat(w)
                let maxiFloat : CGFloat = CGFloat(maxi)
                
                brick = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width/maxiFloat, height: frame.height/25))
                
                //Set the location of the brick
                
                brick.position = CGPoint(x: frame.minX + (2 * ww - 1) * (frame.maxX / maxiFloat), y: frame.maxY - 30 * hh)
                
                brick.name = "brick"
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                
                brick.physicsBody?.isDynamic = false
                
                addChild(brick)
            }
        }
    }
    
    
    func makeLoseZone()
    {
        
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        
        //Set the location of the Lose Zone
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        
        loseZone.name = "loseZone"
        
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
        
    }
    func checkBricks()
    {
        if bricksCount == 0
        {
            maxi += 1
            removeChildren(in: nodes(at: ball.position))
            makeBrick()
            makeBall()
            bricksCount = maxi * maxi
            ballReset = true
        }
    }
    
    
    
}
