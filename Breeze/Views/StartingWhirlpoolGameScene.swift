//
//  StartingWhirlpoolGameScene.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SpriteKit
import GameplayKit
import CoreMotion
import SwiftUI

class StartingWhirlpoolGameScene: SKScene {
    
    @Binding var isPresenting: Bool
    let boat = SKSpriteNode(imageNamed: "boat")
    var backgroundsm = SKSpriteNode(imageNamed: "whirlpool")
    var backgroundmed = SKSpriteNode(imageNamed: "whirlpool")
    var backgroundlrg = SKSpriteNode(imageNamed: "whirlpool")
    
    var timer: Timer?
    var secondsElapsed = 0
    var timeTilTransition = 3

    private let motionManager = CMMotionManager()
    
    init(_ isPresenting: Binding<Bool>) {
        self.isPresenting = isPresenting
    }


    
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
        
        let instructions1 = SKLabelNode(fontNamed: "Baloo 2")
        instructions1.text = "Tilt your phone forward to move the"
        instructions1.fontSize = 20
        instructions1.fontColor = SKColor.black
        instructions1.position = CGPoint(x: frame.midX, y: frame.height - frame.height * 0.20 + 20)
        addChild(instructions1)
        
        let instructions2 = SKLabelNode(fontNamed: "Baloo 2")
        instructions2.text = "boat into the center of the whirlpool."
        instructions2.fontSize = 20
        instructions2.fontColor = SKColor.black
        instructions2.position = CGPoint(x: frame.midX, y: frame.height - frame.height * 0.2)
        addChild(instructions2)
        
        // game scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // boat node
        boat.position = CGPoint(x: frame.size.width / 2, y: 60)
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
        let transition = SKTransition.fade(withDuration: 1.0)
        gameScene?.scaleMode = .aspectFill
        scene?.view?.presentScene(gameScene!, transition: transition)
    }
    
    @objc func fireTimer() {
        
        secondsElapsed += 1
        
        if secondsElapsed == timeTilTransition + 1 {
            swap()
        }
    }
    
    func boatInCenter() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        scene?.physicsWorld.speed = 0
        
        let rotateActionFast = SKAction.rotate(byAngle: .pi / 4, duration: 5)
        let op_rotateActionFast = SKAction.rotate(byAngle: .pi / -4, duration: 5)
        
        backgroundmed.run(rotateActionFast)
        backgroundlrg.run(op_rotateActionFast)
        backgroundsm.run(op_rotateActionFast)
        
        boat.run(rotateActionFast)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let x = boat.position.x
        let y = boat.position.y
        let rad = CGFloat(15)
        if (x > (frame.size.width / 2) - rad && x < (frame.size.width / 2) + rad && y > (frame.size.height / 2) - rad && y < (frame.size.height / 2) + rad){
            boatInCenter()
            //swap()
        }
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
