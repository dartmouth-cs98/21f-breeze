//
//  GameScene.swift
//
//  Created by Sabrina Jain on 10/13/21.
//
import SpriteKit
import GameplayKit
import CoreMotion
import OSLog

class GameScene: SKScene, SKPhysicsContactDelegate {
    //instantiate island
    let currentIsland = UserDefaults.standard.getCurrentIsland();
    let islands = [Islands.island1, Islands.island2, Islands.island3, Islands.island4, Islands.island5]
    lazy var island = islands[currentIsland - 1]
        
    let gameLog = Logger.init(subsystem: "edu.dartmouth.breeze", category: "GameLog")
        
    //instantiate sprites
    lazy var boat = SKSpriteNode(imageNamed: island.boat)
    lazy var dock = SKSpriteNode(imageNamed: island.dock)
    lazy var beach = SKSpriteNode(imageNamed: island.beach)
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
    var countdownStart = 3
    
    //global boundaries
    let left_edge = -325
    let right_edge = 325
    let bottom_edge = -615
    let top_edge = 615
    
    let offscreen_buffer = 100
    
    //obstacle variables (feel free to change these)
    var difficulty = 2
    var seconds_between_obstacle = 2
    var num_obstacles = 3
    var obstacle_speed = 150
    var gap_size = 150
    
    //Don't touch these obstacle variables plz
    var obstacles: Array<String> = []
    var obstacle_count = 0
    var multilevel_obstacle_buffer = 2
    var seconds_elapsed = 0
    var obstacleTimer: Timer?
    var end_level_count = 0
    var beach_is_rendered = false
        
    
    //end scene timer
    var endSceneTimer: Timer?
    var end_scene_delay = 0
    
    var levelTimerLabel = SKLabelNode(fontNamed: "Baloo2-Bold")
    
    private let motionManager = CMMotionManager()
    
//    func setIslandNumber() {
//        switch islandNumber{
//        case 2:
//            island = Islands.island1
//        default:
//            island = Islands.island1
//        }
//    }
    
    //triggered if something changed when you render the screen
    override func didMove(to view: SKView) {
//        setIslandNumber()
        
//        view.showsPhysics = true
        motionManager.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        starfield.particleColor = island.particleColor

    
        self.addChild(starfield)
        
        starfield.particleZPosition = -2

        //background
        print("island: ", island)
        self.backgroundColor = island.backgroundColor
        // game scene physics
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //self.physicsBody?.categoryBitMask = backgroundCategory
        
        // boat node attributes
        boat.position = CGPoint(x: frame.midX + 5, y: frame.minY + 50)
        boat.size = CGSize(width: 70, height: 120)
        boat.removeFromParent()
        self.addChild(boat)
        
        //boat physics
        boat.physicsBody = SKPhysicsBody(texture: boat.texture!, size: boat.size)
        boat.physicsBody?.allowsRotation = false
        boat.physicsBody?.restitution = 0
        boat.physicsBody?.categoryBitMask = boatCategory
        boat.physicsBody?.contactTestBitMask = boatObstacleInteraction
        
        //dock node attributes
        dock.position = CGPoint(x: frame.midX - 58, y: frame.minY)
        dock.size = CGSize(width: 100, height: 300)
        dock.removeFromParent()
        self.addChild(dock)
                      
        //dock physics
        dock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dock.size.width - 60, height: dock.size.height))
        dock.physicsBody?.allowsRotation = false
        dock.physicsBody?.restitution = 0.5
        dock.physicsBody?.isDynamic = false
        
        //set the difficulty
        setDifficulty()
        
        //create obstacle array
        obstacles = createObstacleArray()
        
        //level timer
        levelTimerLabel.fontColor = SKColor.black
        levelTimerLabel.fontSize = 40
        levelTimerLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        levelTimerLabel.text = "Level Starts In: \(countdownStart)"
        self.addChild(levelTimerLabel)
        
        pauseScene()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func setDifficulty() {
        gameLog.notice("Setting difficulty")
        if difficulty == 1 {
            seconds_between_obstacle = 2
            obstacle_speed = 100
            gap_size = 150
        } else if difficulty == 2 {
            seconds_between_obstacle = 2
            obstacle_speed = 135
            gap_size = 130
        } else if difficulty == 3 {
            seconds_between_obstacle = 1
            obstacle_speed = 175
            gap_size = 110
        } else if difficulty == 4 {
            seconds_between_obstacle = 1
            obstacle_speed = 200
            gap_size = 90
        }
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
            let old_count = obstacle_count
            obstacle_count = renderObstacle(count: old_count)
            gameLog.notice("Obstacle count: \(self.obstacle_count)")
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
    
    func createObstacleArray() -> Array<String> {
        let obstacles: [String] = ["basic", "multilevel", "object"]
        var obstacleArray: [String] = []
        var obstacles_left = num_obstacles
        while obstacles_left > 0 {
            let selected = obstacles.randomElement()!
            obstacleArray.append(selected)
            obstacles_left -= 1
            
            if selected == "multilevel"{
                obstacleArray.append("BLANK")
                obstacleArray.append("BLANK")
                num_obstacles += multilevel_obstacle_buffer
            }
        }
        return obstacleArray
    }
    
    func renderObstacle(count: Int) -> Int{
        let curr = obstacles[count]
        if curr == "basic"{
            renderBasicWall()
        } else if curr == "multilevel"{
            renderMultiLevelWall()
        } else if curr == "object" {
            renderObjectObstacle()
        }
        return count + 1
    }

    
    func renderObjectObstacle(){
        let obstacleName = island.obstacles.randomElement()
        let obstacle = SKSpriteNode(imageNamed: obstacleName!)
        obstacle.size = CGSize(width: 200, height: 200)

        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))

        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.contactTestBitMask = boatObstacleInteraction

        //pick object path
        let side = Bool.random()
        let left_point = Int.random(in: left_edge - 50..<left_edge + 50)
        let right_point = Int.random(in: right_edge - 50..<right_edge + 50)
        
        //swap if other side
        var start_point = left_point
        var end_point = right_point
        if  !(side) {
            start_point = right_point
            end_point = left_point
        }

        let path_buffer = 100
        let path = UIBezierPath()
        path.move(to: CGPoint(x: start_point, y: top_edge + path_buffer * 2))
        path.addLine(to: CGPoint(x: end_point, y: bottom_edge - path_buffer * 2))
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
    
        self.addChild(obstacle)
        obstacle.run(move)
    }
    
    func renderBasicWall(){
        let islandColor = island.wallColor
        
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

        
        left_obstacle.fillColor = islandColor
        left_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTexture)!)

        
        right_obstacle.fillColor = islandColor
        right_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTexture)!)

        
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
        let islandColor = island.wallColor
        
        //help obstacles go fully ofscreen
        let path_buffer = 300

        //wall dimensions
        let gap_between_walls = 400
        
        let horizontal_rect_width = 400
        let horizontal_rect_height = 20
        
        let vertical_rect_width = 20
        let vertical_rect_height = 200

        //left or right exiting wall
        let leftExit = Bool.random()
        
        
        //TOP HORIZONTAL OBSTACLE
        var top_horizontal_rect_shape = CGRect(x: left_edge, y: gap_between_walls, width: horizontal_rect_width, height: horizontal_rect_height)
        if leftExit {
            top_horizontal_rect_shape = CGRect(x: right_edge - horizontal_rect_width, y: gap_between_walls, width: horizontal_rect_width, height: horizontal_rect_height)
        }
        let top_horizontal_rect = UIBezierPath(rect: top_horizontal_rect_shape)
        let top_horizontal_obstacle = SKShapeNode(path: top_horizontal_rect.cgPath)
        
        top_horizontal_obstacle.fillColor = islandColor
        top_horizontal_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTexture)!)
     
        top_horizontal_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: top_horizontal_rect_shape)
        top_horizontal_obstacle.physicsBody?.isDynamic = false
        top_horizontal_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        let top_horizontal_path = UIBezierPath()
        top_horizontal_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer ))
        top_horizontal_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let move_top_horizontal = SKAction.follow(top_horizontal_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        //TOP VERTICAL OBSTACLE
        var top_vertical_rect_shape = CGRect(x: left_edge + horizontal_rect_width, y: -vertical_rect_height + horizontal_rect_height + gap_between_walls, width: vertical_rect_width, height: vertical_rect_height)
        if leftExit {
            top_vertical_rect_shape = CGRect(x: right_edge - horizontal_rect_width, y: -vertical_rect_height + horizontal_rect_height + gap_between_walls, width: vertical_rect_width, height: vertical_rect_height)
        }
        let top_vertical_rect = UIBezierPath(rect: top_vertical_rect_shape)
        let top_vertical_obstacle = SKShapeNode(path: top_vertical_rect.cgPath)
        
        top_vertical_obstacle.fillColor = islandColor
        top_vertical_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTextureVert)!)
     
        top_vertical_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: top_vertical_rect_shape)
        top_vertical_obstacle.physicsBody?.isDynamic = false
        top_vertical_obstacle.physicsBody?.categoryBitMask = obstacleCategory
        
        let top_vertical_path = UIBezierPath()
        top_vertical_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer))
        top_vertical_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer * 2))
        let move_top_vertical = SKAction.follow(top_vertical_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))
        
        
        //BOTTOM HORIZONTAL OBSTACLE
        var bottom_rect_start = right_edge - horizontal_rect_width
        var bottom_horizontal_rect_shape = CGRect(x: bottom_rect_start, y: 0, width: horizontal_rect_width, height: horizontal_rect_height)
        if leftExit {
            bottom_rect_start = left_edge
            bottom_horizontal_rect_shape = CGRect(x: bottom_rect_start, y: 0, width: horizontal_rect_width, height: horizontal_rect_height)
        }
        
        let bottom_horizontal_rect = UIBezierPath(rect: bottom_horizontal_rect_shape)
        let bottom_horizontal_obstacle = SKShapeNode(path: bottom_horizontal_rect.cgPath)

        bottom_horizontal_obstacle.fillColor = islandColor
        bottom_horizontal_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTexture)!)


        bottom_horizontal_obstacle.physicsBody = SKPhysicsBody(edgeLoopFrom: bottom_horizontal_rect_shape)
        bottom_horizontal_obstacle.physicsBody?.isDynamic = false
        bottom_horizontal_obstacle.physicsBody?.categoryBitMask = obstacleCategory

        let bottom_horizontal_path = UIBezierPath()
        bottom_horizontal_path.move(to: CGPoint(x: 0, y: top_edge + path_buffer))
        bottom_horizontal_path.addLine(to: CGPoint(x: 0, y: bottom_edge - path_buffer))
        let move_bottom_horizontal = SKAction.follow(bottom_horizontal_path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(obstacle_speed))

        //BOTTOM VERTICAL OBSTACLE
        var bottom_vertical_rect_shape = CGRect(x: bottom_rect_start, y: 0, width: vertical_rect_width, height: vertical_rect_height)
        if leftExit{
            bottom_vertical_rect_shape = CGRect(x: left_edge + horizontal_rect_width, y: 0, width: vertical_rect_width, height: vertical_rect_height)
        }
        let bottom_vertical_rect = UIBezierPath(rect: bottom_vertical_rect_shape)
        let bottom_vertical_obstacle = SKShapeNode(path: bottom_vertical_rect.cgPath)

        bottom_vertical_obstacle.fillColor = islandColor
        bottom_vertical_obstacle.fillTexture = SKTexture(image: UIImage(named: island.wallTextureVert)!)
        
        
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
    
    @objc func fireEndSceneTimer(){
        let end_delay = 0
        if end_scene_delay == end_delay {
            endScene()
        }
        end_scene_delay += 1
    }

    func endScene(){
        UserDefaults.standard.set(false, forKey: "hasntFinishedGame")
        // only "level up" once user has finished the level
        let island = UserDefaults.standard.getCurrentIsland()
        UserDefaults.standard.islandLevelUp(value: island)
        print("made it to end scene")
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        let y = boat.position.y

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
