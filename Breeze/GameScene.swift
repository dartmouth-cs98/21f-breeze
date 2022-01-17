//
//  GameScene.swift
//
//  Created by Sabrina Jain on 10/13/21.
//
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var DEV_MODE = true
    
    var boat = SKSpriteNode(imageNamed: "boat")
    var dock = SKSpriteNode(imageNamed: "dock")
    var beach = SKSpriteNode(imageNamed: "beach")
    var starfield:SKEmitterNode!

    // Category bitmask values
    let backgroundCategory: UInt32 = 0b0000
    let boatCategory: UInt32 = 0b0001 // 1
    let obstacleCategory: UInt32  = 0b0010 // 2
    let goalCategory: UInt32  = 0b0100 // 4
    
    // Interaction bitmask values
    let boatInteraction: UInt32 = 0b0001 // 1 , interaction w/boat
    let obstacleInteraction: UInt32 = 0b0010 // 2 , interaction w/obstacle
    let goalInteraction: UInt32 = 0b0100 // 4 , interaction w/goal
    let boatObstacleInteraction: UInt32 = 0b0010 // 3 , interaction w/ boat and/or obstacle
    let boatGoalInteraction: UInt32 = 0b0101 // 5 , interaction w/ boat and/or goal
    let boatObstacleGoalInteraction: UInt32 = 0b0111 //7 , iteraction w/ obstacle, boat and/or goal
    
    var timer: Timer?
    var runCount = 0
    var countdownStart = 0
    
    //global boundaries
    let left_edge = -325
    let right_edge = 325
    let bottom_edge = -615
    let top_edge = 615
    
    let offscreen_buffer = 100
    
    //obstacle variables (feel free to change these)
    var seconds_between_obstacle = 5
    var num_obstacles = 1
    var obstacle_speed = 150
    
    //Don't touch these obstacle variables plz
    var obstacle_count = 0
    var seconds_elapsed = 0
    var obstacleTimer: Timer?
    var end_level_count = 0
    var beach_is_rendered = false
    
    //end scene timer
    var endSceneTimer: Timer?
    var end_scene_delay = 0
    
    
    var levelTimerLabel = SKLabelNode(fontNamed: "Baloo2-Bold")
    
    private let motionManager = CMMotionManager()
    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
    
        self.addChild(starfield)
        
        starfield.particleZPosition = -2

        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)
        // game scene physics
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //]self.physicsBody?.categoryBitMask = backgroundCategory
        
        // boat node attributes
        boat.position = CGPoint(x: frame.midX + 5, y: frame.minY + 50)
        boat.size = CGSize(width: 100, height: 120)
        boat.removeFromParent()
        self.addChild(boat)
        
        //boat physics
        boat.physicsBody = SKPhysicsBody(circleOfRadius: boat.size.width / 2)
        boat.physicsBody?.allowsRotation = false
        boat.physicsBody?.restitution = 0
        boat.physicsBody?.categoryBitMask = boatCategory
        boat.physicsBody?.contactTestBitMask = boatObstacleInteraction
        
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
        //print(seconds_elapsed)
        //print(end_level_count)
        let end_delay_seconds = 8

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
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 110)
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
       // UserDefaults.standard.set(false, forKey: "hasntFinishedGame")
        //UserDefaults.standard.setGameStatus(value: true)
        
    }
    
    func renderObstacle(){
        renderMultiLevelWall()
        //        renderBasicWall()
        print("render")
    }
    
    func renderBasicWall(){
        //gap between walls
        let gap_size = 150
        
        //height of walls
        let obstacle_height = 20
        
        //adjust boundaries inward so that gap isn't offscreen
        let gap_edge_buffer = 70
        let gap_left_possible_bound = left_edge + gap_edge_buffer
        let gap_right_possible_bound = right_edge - gap_edge_buffer
        
        //location of middle of gap, random int between left edge of screen and right edge
        let gap_center = Int.random(in: gap_left_possible_bound..<gap_right_possible_bound)
        
        //actual left and right side of gap
        let gap_left = gap_center - (gap_size / 2)
        let gap_right = gap_center + (gap_size / 2)
        
        //rect width = length from offscreen buffer to edge of gap
        let left_rect_width = gap_left - (left_edge - offscreen_buffer)
        let left_rect_start = left_edge - offscreen_buffer

        let right_rect_width = (right_edge + offscreen_buffer) - gap_right
        let right_rect_start = gap_right

        
        
        //instantiate barriers
        let left_rect_shape = CGRect(x: left_rect_start, y: 100, width: left_rect_width, height: obstacle_height)
        let right_rect_shape = CGRect(x: right_rect_start, y: 100, width: right_rect_width, height: obstacle_height)
        
        let left_rect = UIBezierPath(rect: left_rect_shape)
        let right_rect = UIBezierPath(rect: right_rect_shape)
        
        let left_obstacle = SKShapeNode(path: left_rect.cgPath)
        let right_obstacle = SKShapeNode(path: right_rect.cgPath)

        left_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        left_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        
        right_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        right_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        
        left_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: left_rect_shape)
        left_obstacle.physicsBody?.isDynamic = false
        left_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        right_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: right_rect_shape)
        right_obstacle.physicsBody?.isDynamic = false
        right_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        
//        create barrier paths
        let path_buffer = 100
        let leftObstaclePath = UIBezierPath()
        leftObstaclePath.move(to: CGPoint(x: 0, y: top_edge))
        leftObstaclePath.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let moveLeft = SKAction.follow(leftObstaclePath.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))

        let rightObstaclePath = UIBezierPath()
        rightObstaclePath.move(to: CGPoint(x: 0, y: top_edge))
        rightObstaclePath.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let moveRight = SKAction.follow(rightObstaclePath.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        //start barriers
        self.addChild(left_obstacle)
        self.addChild(right_obstacle)
        left_obstacle.run(moveLeft)
        right_obstacle.run(moveRight)
    }
    
    func renderMultiLevelWall(){
        //help obstacles go fully ofscreen
        let path_buffer = 300

        //wall dimensions
        let gap_between_walls = 400
        
        let horizontal_rect_width = 400
        let horizontal_rect_height = 20
        
        let vertical_rect_width = 20
        let vertical_rect_height = 200

//        let rightExit = Bool.random()
        
        //TOP HORIZONTAL OBSTACLE
        let top_horizontal_rect_shape = CGRect(x: left_edge, y: gap_between_walls, width: horizontal_rect_width, height: horizontal_rect_height)
        let top_horizontal_rect = UIBezierPath(rect: top_horizontal_rect_shape)
        let top_horizontal_obstacle = SKShapeNode(path: top_horizontal_rect.cgPath)
        
        top_horizontal_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        top_horizontal_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
     
        top_horizontal_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: top_horizontal_rect_shape)
        top_horizontal_obstacle.physicsBody?.isDynamic = false
        top_horizontal_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        let top_horizontal_path = UIBezierPath()
        top_horizontal_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer ))
        top_horizontal_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let move_top_horizontal = SKAction.follow(top_horizontal_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        //TOP VERTICAL OBSTACLE
        let top_vertical_rect_shape = CGRect(x: left_edge + horizontal_rect_width, y: -vertical_rect_height + horizontal_rect_height + gap_between_walls, width: vertical_rect_width, height: vertical_rect_height)
        let top_vertical_rect = UIBezierPath(rect: top_vertical_rect_shape)
        let top_vertical_obstacle = SKShapeNode(path: top_vertical_rect.cgPath)
        
        top_vertical_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        top_vertical_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
     
        top_vertical_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: top_vertical_rect_shape)
        top_vertical_obstacle.physicsBody?.isDynamic = false
        top_vertical_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        let top_vertical_path = UIBezierPath()
        top_vertical_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer))
        top_vertical_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let move_top_vertical = SKAction.follow(top_vertical_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        
        //BOTTOM HORIZONTAL OBSTACLE
        let bottom_rect_start = right_edge - horizontal_rect_width
        let bottom_horizontal_rect_shape = CGRect(x: bottom_rect_start, y: 0, width: horizontal_rect_width, height: horizontal_rect_height)
        let bottom_horizontal_rect = UIBezierPath(rect: bottom_horizontal_rect_shape)
        let bottom_horizontal_obstacle = SKShapeNode(path: bottom_horizontal_rect.cgPath)

        bottom_horizontal_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        bottom_horizontal_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)

        bottom_horizontal_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: bottom_horizontal_rect_shape)
        bottom_horizontal_obstacle.physicsBody?.isDynamic = false
        bottom_horizontal_obstacle.physicsBody?.categoryBitMask = obstacleCategory

        let bottom_horizontal_path = UIBezierPath()
        bottom_horizontal_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer))
        bottom_horizontal_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer))
        let move_bottom_horizontal = SKAction.follow(bottom_horizontal_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))

        //BOTTOM VERTICAL OBSTACLE
        let bottom_vertical_rect_shape = CGRect(x: bottom_rect_start, y: 0, width: vertical_rect_width, height: vertical_rect_height)
        let bottom_vertical_rect = UIBezierPath(rect: bottom_vertical_rect_shape)
        let bottom_vertical_obstacle = SKShapeNode(path: bottom_vertical_rect.cgPath)

        bottom_vertical_obstacle.fillColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)
        bottom_vertical_obstacle.strokeColor = UIColor(red: 145/255, green: 142/255, blue: 133/255, alpha: 1)

        bottom_vertical_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: bottom_vertical_rect_shape)
        bottom_vertical_obstacle.physicsBody?.isDynamic = false
        bottom_vertical_obstacle.physicsBody?.categoryBitMask = obstacleCategory

        let bottom_vertical_path = UIBezierPath()
        bottom_vertical_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer))
        bottom_vertical_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer))
        let move_bottom_vertical = SKAction.follow(bottom_vertical_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))

        
        //ADD OBSTACLES
        self.addChild(top_horizontal_obstacle)
        top_horizontal_obstacle.run(move_top_horizontal)
        
        self.addChild(top_vertical_obstacle)
        top_vertical_obstacle.run(move_top_vertical)
        
        self.addChild(bottom_horizontal_obstacle)
        bottom_horizontal_obstacle.run(move_bottom_horizontal)

        self.addChild(bottom_vertical_obstacle)
        bottom_vertical_obstacle.run(move_bottom_vertical)
//
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print(contact.bodyA)
        //print(contact.bodyB)
        //print(contact.contactPoint)
    }
    
    @objc func fireEndSceneTimer(){
        let end_delay = 0
        if end_scene_delay == end_delay {
            endScene()
        }
        end_scene_delay += 1
    }
    
    func endScene(){
        UserDefaults.standard.set(false, forKey: "hasntFinishedGame")
    }
    
    override func update(_ currentTime: TimeInterval) {
        let y = boat.position.y
//        print(boat.position)

        if (y < frame.minY) {
            scene?.view?.isPaused = true
            UserDefaults.standard.set(false, forKey: "hasntLostGame")
        }
        if beach_is_rendered {
            if (y > (frame.maxY * 0.8)){ // top 1/10th of screen
                scene?.view?.isPaused = true
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireEndSceneTimer), userInfo: nil, repeats: true)
            }
        } else {
            if boat.position.y >= frame.maxY * 0.6 {
                boat.position.y = frame.maxY * 0.6 - 1
            }
        }
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
    
}
