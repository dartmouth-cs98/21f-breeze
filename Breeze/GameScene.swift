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
    var starfield:SKEmitterNode!

    
    var timer: Timer?
    var runCount = 0
    var countdownStart = 5
    
    var levelTimerLabel = SKLabelNode(fontNamed: "Baloo2-Bold")
    
    private let motionManager = CMMotionManager()

    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1

        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)
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
        levelTimerLabel.text = "Level Starts In: \(countdownStart)"
        self.addChild(levelTimerLabel)
        
        pauseScene()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func fireTimer() {
        updateTimerLabel(count: runCount)
        runCount += 1
        
        if runCount == countdownStart + 1 {
            levelTimerLabel.removeFromParent()
            timer?.invalidate()
            unpauseScene()
        }
    }
    
    func updateTimerLabel(count: Int){
        let timeLeft = countdownStart - count
        levelTimerLabel.text = "Level Starts In: \(timeLeft)"
    }
    
    func pauseScene(){
        scene?.physicsWorld.speed = 0
    }
    
    func unpauseScene(){
        scene?.physicsWorld.speed = 1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.midX, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.midX, y: -1000))
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 110)
        dock.yScale = -1
        dock.xScale = -1
        dock.run(move)
    }
    
    override func update(_ currentTime: TimeInterval) {

        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
