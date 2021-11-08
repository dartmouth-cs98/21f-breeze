//
//  GameScene.swift
//
//  Created by Sabrina Jain on 10/13/21.
//
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var boat = SKSpriteNode(imageNamed: "boat")
    var dock = SKSpriteNode(imageNamed: "dock")
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")

    var levelTimerValue: Int = 10 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    
    private let motionManager = CMMotionManager()

    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        

        //background
        self.backgroundColor = SKColor.white
        
        // game scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // boat node attributes
        boat.position = CGPoint(x: frame.midX + 5, y: frame.minY + 50)
        boat.size = CGSize(width: 100, height: 120)
        boat.removeFromParent()
        self.addChild(boat)
        
        //boat physics
        boat.physicsBody = SKPhysicsBody(circleOfRadius: boat.size.width / 2)
        boat.physicsBody?.allowsRotation = false
        boat.physicsBody?.restitution = 0.5
        
        //dock node attributes
        dock.position = CGPoint(x: frame.midX - 58, y: frame.minY)
        dock.size = CGSize(width: 100, height: 300)
        self.addChild(dock)
                      
        //dock physics
        dock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dock.size.width - 60, height: dock.size.height))
        dock.physicsBody?.allowsRotation = false
        dock.physicsBody?.restitution = 0.5
        dock.physicsBody?.isDynamic = false
        
        //level timer
        levelTimerLabel.fontColor = SKColor.black
        levelTimerLabel.fontSize = 40
        levelTimerLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        self.addChild(levelTimerLabel)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run(_:)({
               [unowned self] in

               if self.levelTimerValue > 0{
                   self.levelTimerValue -= 1
                   print("working")
               }else{
                   self.removeAction(forKey: "countdown")
               }
           })
           let sequence = SKAction.sequence([wait,block])

        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
//        pauseScene()
    }
    
    
    func pauseScene(){
        scene?.physicsWorld.speed = 0
    }
    
    override func update(_ currentTime: TimeInterval) {

        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
        
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
}
