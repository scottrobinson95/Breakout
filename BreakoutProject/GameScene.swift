//
//  GameScene.swift
//  BreakoutProject
//
//  Created by Srobinson1 on 3/16/17.
//  Copyright © 2017 Srobinson1. All rights reserved.
//
//MVP: ​As a user, I want a game that follows the same rules as Breakout. There needs to be multiple column/row format
//which span the width of the screen. The game should begin when a button is pushed. The ball should be given a push and
//the ball should bounce off sides and the paddle. When the ball hits a Block, the Block should be removed from the screen.
//Stretch #1: ​As a user, I want to display a message when the level is complete or 3 balls have been lost.
//Stretch #2: ​As a user, I want to display the number of lives/balls and a score for the game
//Stretch #3: ​As a user, I want to create a better UI experience. This may include animations, images in place of SKNode
//shapes, sound, etc.
//Stretch #4:​ As a user, I want multiple levels, different block patterns, multiple balls, increased speed, etc.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var ball: SKSpriteNode!
    
    var paddle: SKSpriteNode!
    
    var brick: SKSpriteNode!
    
    let startLabel = SKLabelNode()
    
    let ballCountLabel = SKLabelNode()
    
    let bricksDestroyedLabel = SKLabelNode()
    
    var maxi = 3
    
    var bricksCount = 9
    
    var ballCount = 3
    
    var ballReset = true
    
    var bricksDestroyed = 0
    
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        //Constraint around edge of view so that ball doesn't fall off of the screen
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makePaddle()
        
        makeBall()
        
        makeBrick()
        
        makeLoseZone()
        
        makeLabel(labelName: startLabel, labelText: "Touch Paddle to Start", labelFontSize: 30, labelFontColor: UIColor.white, labelPosition: CGPoint(x: frame.midX, y: frame.minY + 75))
        makeLabel(labelName: ballCountLabel, labelText: "Balls: \(ballCount)", labelFontSize: 30, labelFontColor: UIColor.white, labelPosition: CGPoint(x: frame.minX + 50, y: frame.minY + 80))
        makeLabel(labelName: bricksDestroyedLabel, labelText: "Bricks Destroyed: \(bricksDestroyed)", labelFontSize: 30, labelFontColor: UIColor.white, labelPosition: CGPoint(x: frame.minX + 124, y: frame.minY + 55))
        ballCountLabel.isHidden = true
        bricksDestroyedLabel.isHidden = true
        
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
            ball.physicsBody?.applyImpulse(CGVector(dx: maxi, dy: maxi))
            ballReset = false
        }
        startLabel.isHidden = true
        ballCountLabel.isHidden = false
        bricksDestroyedLabel.isHidden = false
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
            ball.physicsBody?.applyImpulse(CGVector(dx: maxi, dy: maxi))
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
            bricksDestroyed += 1
            checkBricks()
        }
        else if contact.bodyB.node?.name == "brick"
        {
            print("brick hit")
            removeChildren(in: nodes(at: (contact.bodyB.node?.position)!))
            bricksCount -= 1
            bricksDestroyed += 1
            checkBricks()
        }
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("You Lose")
            ballCount -= 1
            removeChildren(in: nodes(at: ball.position))
            makeBall()
            ballReset = true
            ballCountLabel.text = "Balls: \(ballCount)"
            checkGameOver()
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
    
    func makeLabel(labelName: SKLabelNode,labelText: String, labelFontSize: CGFloat, labelFontColor: UIColor, labelPosition: CGPoint)
    {
        
        labelName.text = labelText
        labelName.fontSize = labelFontSize
        labelName.position = labelPosition
        labelName.fontColor = labelFontColor
        
        addChild(labelName)
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
        bricksDestroyedLabel.text = "Bricks Destroyed: \(bricksDestroyed)"
    }
    
    func checkGameOver()
    {
        if ballCount == 0
        {
            let gameOverAlert = UIAlertController(title: "Game Over", message: "Score: \(bricksDestroyed)", preferredStyle: UIAlertControllerStyle.alert)
            let resetButton = UIAlertAction(title: "Restart?", style: UIAlertActionStyle.default, handler:
                {(sender) in
                    self.ballCount = 3
                    self.ballCountLabel.text = "Balls: \(self.ballCount)"
                    self.bricksDestroyed = 0
                    self.bricksDestroyedLabel.text = "Bricks Destroyed: \(self.bricksDestroyed)"
                    self.ballReset = true
                    self.maxi = 3
                    self.startLabel.isHidden = false
                    self.bricksDestroyedLabel.isHidden = true
                    self.ballCountLabel.isHidden = true
                    self.removeAllChildren()
                    self.makePaddle()
                    self.makeBall()
                    self.makeBrick()
                    self.makeLoseZone()
                    
            })
            gameOverAlert.addAction(resetButton)
            self.view?.window?.rootViewController?.present(gameOverAlert, animated: true, completion: nil)
        }
    }
}
