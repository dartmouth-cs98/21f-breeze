//
//  StartingWhirlpoolGameScene.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class StartingWhirlpoolGameScene: SKScene {
    
    let boat = SKSpriteNode(imageNamed: "boat")
    var backgroundsm = SKSpriteNode(imageNamed: "whirlpool")
    var backgroundmed = SKSpriteNode(imageNamed: "whirlpool")
    var backgroundlrg = SKSpriteNode(imageNamed: "whirlpool")

    
    private let motionManager = CMMotionManager()

    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        
       

        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)

        backgroundlrg.size = CGSize(width: 700, height: 700)
        backgroundlrg.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let op_rotateAction = SKAction.rotate(byAngle: .pi / -2, duration: 10)
        backgroundlrg.run(SKAction.repeatForever(op_rotateAction))
        backgroundlrg.removeFromParent()
        addChild(backgroundlrg)
        
        backgroundmed.size = CGSize(width: 500, height: 500)
        backgroundmed.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 10)
        backgroundmed.run(SKAction.repeatForever(rotateAction))
        backgroundmed.removeFromParent()
        addChild(backgroundmed)
        
        backgroundsm.size = CGSize(width: 300, height: 300)
        backgroundsm.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        backgroundsm.run(SKAction.repeatForever(op_rotateAction))
        backgroundsm.removeFromParent()
        addChild(backgroundsm)
        
        // game scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // boat node
        boat.position = CGPoint(x: frame.size.width, y: 60)
        boat.size = CGSize(width: 70, height: 90)
        boat.removeFromParent()
        self.addChild(boat)
        
        //boat physics
        boat.physicsBody = SKPhysicsBody(circleOfRadius: boat.size.width / 2)
        boat.physicsBody?.allowsRotation = false
        boat.physicsBody?.restitution = 0.5
        
       
    }
    
    func swap() {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fade(withDuration: 2.0)
        gameScene?.scaleMode = .aspectFill
        scene?.view?.presentScene(gameScene!, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let x = boat.position.x
        let y = boat.position.y
        let rad = 15
        if (x > (frame.size.width / 2) - CGFloat(rad) && x < (frame.size.width / 2) + CGFloat(rad) && y > (frame.size.height / 2) - CGFloat(rad) && y < (frame.size.height / 2) + CGFloat(rad)){
            swap()
        }
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
