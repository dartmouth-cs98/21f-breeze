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
    var beach = SKSpriteNode(imageNamed: "beach")
    var starfield:SKEmitterNode!

    
    var timer: Timer?
    var runCount = 0
    var countdownStart = 3
    
    //obstacle variables (feel free to change these)
    var seconds_between_obstacle = 3
    var num_obstacles = 2
    var obstacle_speed = 150
    var gap_size = 20
    
    //Don't touch these obstacle variables plz
    var obstacle_count = 0
    var seconds_elapsed = 0
    var obstacleTimer: Timer?
    var end_level_count = 0
    var beach_is_rendered = false
    
    var levelTimerLabel = SKLabelNode(fontNamed: "Baloo2-Bold")
    
    private let motionManager = CMMotionManager()

    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
    
        self.addChild(starfield)
        
        starfield.particleZPosition = -2

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
        
        //When start-of-level timer is over, remove it and resume scene
        if runCount == countdownStart + 1 {
            levelTimerLabel.removeFromParent()
            timer?.invalidate()
            unpauseScene()
        }
    }
    
    @objc func fireObstacleTimer() {
        let end_delay_seconds = 10

        //release obstacles at an interval while num_obstacles hasn't been reached
        if obstacle_count < num_obstacles && seconds_elapsed % seconds_between_obstacle == 0 {
            obstacle_count += 1
            renderObstacle()
        }
        
        //instantiate end-of-level timer for beach
        if obstacle_count == num_obstacles {
            end_level_count += 1
        }
        
        //render beach
        if end_level_count == end_delay_seconds {
            renderLevelEnd()
        }
        seconds_elapsed += 1
    }
    
    func updateTimerLabel(count: Int){
        let timeLeft = countdownStart - count
        levelTimerLabel.text = "Level Starts In: \(timeLeft)"
    }
    
    func pauseScene(){
        scene?.physicsWorld.speed = 0
    }
    
    func unpauseScene(){
        //allow stuff to move again
        scene?.physicsWorld.speed = 1
        
        //move dock away
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.midX, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.midX, y: -1000))
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 110)
        dock.yScale = -1
        dock.xScale = -1
        dock.run(move)
        
        //begin timer that tracks obstacles
        obstacleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireObstacleTimer), userInfo: nil, repeats: true)
    }
    
    func renderLevelEnd(){
        //instantiate beach
        beach.size = CGSize(width: frame.width, height: 200)
        beach.zPosition = -1
        self.addChild(beach)
        
        //beach movement
        let beachPath = UIBezierPath()
        beachPath.move(to: CGPoint(x: frame.midX, y: frame.maxY + 20))
        beachPath.addLine(to: CGPoint(x: frame.midX, y: frame.maxY - 70))
        let beachMove = SKAction.follow(beachPath.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(80))
    
        beach.run(beachMove)
        
        //prep end of level stuff
        beach_is_rendered = true
        starfield.isPaused = true
    }
    
    func renderObstacle(){
        //pick gap
        let gap_center = Int.random(in: -250..<250)
        let left_rect_width = (275 + gap_center - (gap_size / 2))
        let right_rect_start = (gap_center + (gap_size / 2))
        
        //instantiate barriers
        let left_rect_shape = CGRect(x: -420, y: 0, width: left_rect_width, height: 20)
        let right_rect_shape = CGRect(x: right_rect_start, y: 0, width: Int(frame.width) / 2, height: 20)
        
        let left_rect = UIBezierPath(rect: left_rect_shape)
        let right_rect = UIBezierPath(rect: right_rect_shape)
        
        let left_obstacle = SKShapeNode(path: left_rect.cgPath)
        let right_obstacle = SKShapeNode(path: right_rect.cgPath)

        left_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        left_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        
        right_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        right_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        
        //create barrier paths
        let leftObstaclePath = UIBezierPath()
        leftObstaclePath.move(to: CGPoint(x: 100, y: 700))
        leftObstaclePath.addLine(to: CGPoint(x: 100, y: frame.minY - 30))
        let moveLeft = SKAction.follow(leftObstaclePath.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        let rightObstaclePath = UIBezierPath()
        rightObstaclePath.move(to: CGPoint(x: 200, y: 700))
        rightObstaclePath.addLine(to: CGPoint(x: 200, y: frame.minY - 30))
        let moveRight = SKAction.follow(rightObstaclePath.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        //start barriers
        addChild(left_obstacle)
        addChild(right_obstacle)
        left_obstacle.run(moveLeft)
        right_obstacle.run(moveRight)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let y = boat.position.y
        if beach_is_rendered {
            if (y > (frame.maxY * 0.8)){ // top 1/10th of screen
                  pauseScene()
            }
        }
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
