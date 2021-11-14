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
    var background = SKSpriteNode(imageNamed: "whirlpool")

    
    private let motionManager = CMMotionManager()

    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        
       

        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)

        background.size = CGSize(width: 400, height: 400)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.removeFromParent()
        addChild(background)
        
        // game scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // boat node
        boat.position = CGPoint(x: 60, y: 60)
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
        if (x > 200 && x < 220 && y > 440 && y < 455){
            swap()
        }
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
