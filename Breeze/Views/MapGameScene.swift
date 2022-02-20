//
//  MapGameScene.swift
//  Breeze
//
//  Created by Laurel Dernbach on 1/22/22.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI
import OSLog

class MapGameScene: SKScene {
    
    //var screenWidth = screenSize.width
    //var screenHeight = screenSize.height
    
    var screenSize: CGRect = UIScreen.main.bounds
    lazy var screenWidth = screenSize.width
    lazy var screenHeight = screenSize.height
    
    let gameLog = Logger.init(subsystem: "edu.dartmouth.breeze", category: "GameLog")

    var island_size = CGFloat(125)
    var island1 = SKSpriteNode(imageNamed: "sandisland")
    var island2 = SKSpriteNode(imageNamed: "ice island")
    var island3 = SKSpriteNode(imageNamed: "sun island")
    var island4 = SKSpriteNode(imageNamed: "city island")
    var island5 = SKSpriteNode(imageNamed: "lighthouse island")

    var island1label = SKLabelNode()
    var island2label = SKLabelNode()
    var island3label = SKLabelNode()
    var island4label = SKLabelNode()
    var island5label = SKLabelNode()
    
    var boat = SKSpriteNode(imageNamed: "boat")
    var mapDock = SKSpriteNode(imageNamed: "dock")

    let boat_speed = 100
    
    let num_levels = 1
    
    override func didMove(to view: SKView) {
        
        // map reset if necessary (comment out until needed)
        // sets all islands back to lvl 1 (thus "locking" islands 2-5)
//        UserDefaults.standard.resetMap()
        
        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)
        

        print("width: ")
        print(screenWidth)
        print("height: ")
        print(screenHeight)
        
        island1.size = CGSize(width: island_size, height: island_size)
        island1.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.20)
        island1.name = "island1"
        island1.removeFromParent()
        addChild(island1)
        island1label = SKLabelNode(fontNamed: "Baloo 2")
        // island1 always starts unlocked
        island1label.text = "Island Open"
        if (UserDefaults.standard.islandGetLevel(value: 1) >= 1 && UserDefaults.standard.islandGetLevel(value: 1) <= num_levels) {
            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + "/ \(num_levels)"
        } else if UserDefaults.standard.islandGetLevel(value: 1) > num_levels {
            island1label.text = "Level: " + "\(num_levels) " + "/ \(num_levels)"
        }
        island1label.fontSize = 10
        island1label.fontColor = SKColor.black
        island1label.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.20 - island_size*0.5)
        addChild(island1label)

        
        island2.size = CGSize(width: island_size, height: island_size)
        island2.position = CGPoint(x: screenWidth * 0.25, y: screenHeight * 0.35)
        island2.name = "island2"
        island2.removeFromParent()
        addChild(island2)
        island2label = SKLabelNode(fontNamed: "Baloo 2")
        island2label.text = "Island Locked"
        island2.alpha = 0.4
        if UserDefaults.standard.islandGetLevel(value: 2) == 0 && UserDefaults.standard.islandGetLevel(value: 1) > num_levels {
            island2label.text = "Island Open"
            island2.alpha = 1
        } else if (UserDefaults.standard.islandGetLevel(value: 2) >= 1 && UserDefaults.standard.islandGetLevel(value: 2) <= num_levels) {
            island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + "/ \(num_levels)"
            island2.alpha = 1

        } else if UserDefaults.standard.islandGetLevel(value: 2) > num_levels {
            island2label.text = "Level: " + "\(num_levels) " + "/ \(num_levels)"
            island2.alpha = 1
        }
        island2label.fontSize = 10
        island2label.fontColor = SKColor.black
        island2label.position = CGPoint(x: screenWidth * 0.25, y: screenHeight * 0.35 - island_size*0.5)
        addChild(island2label)
        
        island3.size = CGSize(width: island_size, height: island_size)
        island3.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.50)
        island3.name = "island3"
        island3.removeFromParent()
        addChild(island3)
        island3label = SKLabelNode(fontNamed: "Baloo 2")
        island3label.text = "Island Locked"
        island3.alpha = 0.4
        
        if UserDefaults.standard.islandGetLevel(value: 3) == 0 && UserDefaults.standard.islandGetLevel(value: 2) > num_levels {
            island3label.text = "Island Open"
            island3.alpha = 1
        } else if (UserDefaults.standard.islandGetLevel(value: 3) >= 1 && UserDefaults.standard.islandGetLevel(value: 3) <= num_levels) {
            island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + "/ \(num_levels)"
            island3.alpha = 1
        } else if UserDefaults.standard.islandGetLevel(value: 3) > num_levels {
            island3label.text = "Level: " + "\(num_levels) " + "/ \(num_levels)"
            island3.alpha = 1
        }
        island3label.fontSize = 10
        island3label.fontColor = SKColor.black
        island3label.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.50 - island_size*0.5)
        addChild(island3label)
        
        island4.size = CGSize(width: island_size, height: island_size)
        island4.position = CGPoint(x: screenWidth * 0.25, y: screenHeight * 0.65)
        island4.name = "island4"
        island4.removeFromParent()
        addChild(island4)
        island4label = SKLabelNode(fontNamed: "Baloo 2")
        island4label.text = "Island Locked"
        island4.alpha = 0.4
        if UserDefaults.standard.islandGetLevel(value: 4) == 0 && UserDefaults.standard.islandGetLevel(value: 3) > num_levels {
            island4label.text = "Island Open"
            island4.alpha = 1
        } else if (UserDefaults.standard.islandGetLevel(value: 4) >= 1 && UserDefaults.standard.islandGetLevel(value: 4) <= num_levels) {
            island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + "/ \(num_levels)"
            island4.alpha = 1

        } else if UserDefaults.standard.islandGetLevel(value: 4) > num_levels {
            island4label.text = "Level: " + "\(num_levels) " + "/ \(num_levels)"
            island4.alpha = 1
        }
        island4label.fontSize = 10
        island4label.fontColor = SKColor.black
        island4label.position = CGPoint(x: screenWidth * 0.25, y: screenHeight * 0.65 - island_size*0.5)
        addChild(island4label)
        
        island5.size = CGSize(width: island_size, height: island_size)
        island5.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.80)
        island5.name = "island5"
        island5.removeFromParent()
        addChild(island5)
        island5label = SKLabelNode(fontNamed: "Baloo 2")
        island5label.text = "Island Locked"
        island5.alpha = 0.4
        if UserDefaults.standard.islandGetLevel(value: 5) == 0 && UserDefaults.standard.islandGetLevel(value: 4) > num_levels {
            island5label.text = "Island Open"
            island5.alpha = 1
        } else if (UserDefaults.standard.islandGetLevel(value: 5) >= 1 && UserDefaults.standard.islandGetLevel(value: 5) <= num_levels) {
            island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + "/ \(num_levels)"
            island5.alpha = 1

        } else if UserDefaults.standard.islandGetLevel(value: 5) > num_levels {
            island5label.text = "Level: " + "\(num_levels) " + "/ \(num_levels)"
            island5.alpha = 1

        }
        island5label.fontSize = 10
        island5label.fontColor = SKColor.black
        island5label.position = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.80 - island_size*0.5)
        addChild(island5label)
        
        let islandPositions = [CGPoint(x: screenWidth * 0.2 + 30,  y: frame.minY + 30), island1.position, island2.position, island3.position, island4.position, island5.position]
        
//        boat.position = CGPoint(x: frame.size.width * 0.2 + 30, y: frame.minY + 30)
        boat.position = islandPositions[UserDefaults.standard.getCurrentIsland()]
        boat.size = CGSize(width: 70 * 0.5, height: 120 * 0.5)
        boat.removeFromParent()
        self.addChild(boat)
        
        mapDock.position = CGPoint(x: screenWidth * 0.2 , y: frame.minY)
        mapDock.size = CGSize(width: 100 * 0.5, height: 300 * 0.5)
        mapDock.removeFromParent()
        self.addChild(mapDock)
        
        let instructions1 = SKLabelNode(fontNamed: "Baloo 2")
        instructions1.text = "Tap an island to play! To unlock an island, play all the levels of the previous island on the map."
        instructions1.fontSize = 15
        instructions1.fontColor = SKColor.black
        instructions1.position = CGPoint(x: screenWidth * 0.30, y: screenHeight * 0.75)
        instructions1.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructions1.numberOfLines = 4
        instructions1.preferredMaxLayoutWidth = screenWidth * 0.5
        addChild(instructions1)
        
        dottedLine(from: mapDock.position, to: island1.position)
        dottedLine(from: island1.position, to: island2.position)
        dottedLine(from: island2.position, to: island3.position)
        dottedLine(from: island3.position, to: island4.position)
        dottedLine(from: island4.position, to: island5.position)
        dottedLine(from: island5.position, to: CGPoint(x: screenWidth * 0.5, y: screenHeight))
        
        let textShadow = SKShapeNode(rect: CGRect(x: screenWidth * 0.05, y: screenHeight * 0.75, width: 200, height: 125))
        textShadow.strokeColor = UIColor(red: 131/255, green: 205/255, blue: 230/255, alpha: 1)
        textShadow.glowWidth = 20
        textShadow.fillColor = UIColor(red: 131/255, green: 205/255, blue: 230/255, alpha: 1)
        textShadow.zPosition = -1
        addChild(textShadow)
        
        //USER TESTING CODE (DELETE LATER)
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            instructions1.text = "Tap an island to play! To unlock an island, play all the levels of the previous island on the map. TESTING ID: " + uuid
        }
        else {
            instructions1.text = "Tap an island to play! To unlock an island, play all the levels of the previous island on the map."
        }
        //USER TESTING CODE FINISH
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = self.nodes(at: location)
                for node in touchedNode {
                    if node.name == "island1" {
                        if UserDefaults.standard.islandGetLevel(value: 1) == 0 {
                            // 78move boat
                            UserDefaults.standard.islandLevelUp(value: 1)
                            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + " / \(num_levels)"
                            moveSprite(pointA: mapDock.position, pointB: island1.position)
                            break
                        }
                        else if UserDefaults.standard.islandGetLevel(value: 1) >= num_levels {
                            island1label.text = "Level: \(num_levels) / \(num_levels)"
                        } else {
                            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + " / \(num_levels)"
                        }
                        UserDefaults.standard.setCurrentIsland(value: 1)
                        startGame()
                    }
                    
                    if node.name == "island2" {
                        if UserDefaults.standard.islandGetLevel(value: 1) < num_levels {
                            shakeSprite(layer: island2, duration: 0.5)
                        }
                        else {
                            if UserDefaults.standard.islandGetLevel(value: 2) == 0 {
                                //move boat
                                UserDefaults.standard.islandLevelUp(value: 2)
                                island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + " / \(num_levels)"
                                moveSprite(pointA: island1.position, pointB: island2.position)
                            }
                            else{
                                if UserDefaults.standard.islandGetLevel(value: 2) == num_levels {
                                        island2label.text = "Level: \(num_levels) / \(num_levels)"
                                } else {
                                    island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + " / \(num_levels)"
                                }
                                UserDefaults.standard.setCurrentIsland(value: 2)
                                startGame()
                            }
                        }
                    }
                    
                    if node.name == "island3" {
                        if UserDefaults.standard.islandGetLevel(value: 2) < num_levels {
                            shakeSprite(layer: island3, duration: 0.5)
                        }
                        else {
                            if UserDefaults.standard.islandGetLevel(value: 3) == 0 {
                                //move boat
                                UserDefaults.standard.islandLevelUp(value: 3)
                                island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + " / \(num_levels)"
                                moveSprite(pointA: island2.position, pointB: island3.position)
                            }
                            else{
                                if UserDefaults.standard.islandGetLevel(value: 3) == num_levels {
                                        island3label.text = "Level: \(num_levels) / \(num_levels)"
                                } else {
                                    island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + " / \(num_levels)"
                                }
                                UserDefaults.standard.setCurrentIsland(value: 3)
                                startGame()
                            }
                        }
                    }
                    
                    if node.name == "island4" {
                        if UserDefaults.standard.islandGetLevel(value: 3) < num_levels {
                            shakeSprite(layer: island4, duration: 0.5)
                        }
                        else {
                            if UserDefaults.standard.islandGetLevel(value: 4) == 0 {
                                //move boat
                                UserDefaults.standard.islandLevelUp(value: 4)
                                island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + " / \(num_levels)"
                                moveSprite(pointA: island3.position, pointB: island4.position)
                            }
                            else{
                                if UserDefaults.standard.islandGetLevel(value: 4) == num_levels {
                                        island4label.text = "Level: \(num_levels) / \(num_levels)"
                                } else {
                                    island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + " / \(num_levels)"
                                }
                                UserDefaults.standard.setCurrentIsland(value: 4)
                                startGame()
                            }
                        }
                    }
                    
                    if node.name == "island5" {
                        if UserDefaults.standard.islandGetLevel(value: 4) < num_levels {
                            shakeSprite(layer: island5, duration: 0.5)
                        }
                        else {
                            if UserDefaults.standard.islandGetLevel(value: 5) == 0 {
                                //move boat
                                UserDefaults.standard.islandLevelUp(value: 5)
                                island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + " / \(num_levels)"
                                moveSprite(pointA: island4.position, pointB: island5.position)
                            }
                            else{
                                if UserDefaults.standard.islandGetLevel(value: 5) == num_levels {
                                        island5label.text = "Level: \(num_levels) / \(num_levels)"
                                } else {
                                    island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + " / \(num_levels)"
                                }
                                UserDefaults.standard.setCurrentIsland(value: 5)
                                startGame()
                            }
                        }
                    }
                }
            }
        }
    
    func moveSprite(pointA: CGPoint, pointB: CGPoint){
        gameLog.notice("in sprite movement")
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addLine(to: pointB)
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: CGFloat(boat_speed))
        boat.run(move)
    }
    
    // shake function by Ged2323 https://gist.github.com/mihailt/d793236f31f0b8f8722e
    func shakeSprite(layer:SKSpriteNode, duration:Float) {
            
            let position = layer.position
            
            let amplitudeX:Float = 10
            let amplitudeY:Float = 6
            let numberOfShakes = duration / 0.04
            var actionsArray:[SKAction] = []
            for _ in 1...Int(numberOfShakes) {
                let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
                let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
                let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
                shakeAction.timingMode = SKActionTimingMode.easeOut
                actionsArray.append(shakeAction)
                actionsArray.append(shakeAction.reversed())
            }
            
            actionsArray.append(SKAction.move(to: position, duration: 0.0))
            
            let actionSeq = SKAction.sequence(actionsArray)
            layer.run(actionSeq)
        }
    
    func startGame() {
        let transition = SKTransition.fade(withDuration: 1.0)
        let whirlpool = StartingWhirlpoolGameScene(size: self.size)
        whirlpool.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(whirlpool, transition:transition)
    }
    
    
    func dottedLine(from: CGPoint, to: CGPoint) {
        let pattern : [CGFloat] = [10.0, 10.0]
        let path = CGMutablePath.init()

        path.addLines(between: [from, to])

        let dashedPath = path.copy(dashingWithPhase: 1, lengths: pattern)

        let line = SKShapeNode(path: dashedPath)
        line.zPosition = -1
        line.strokeColor = UIColor(red: 131/255, green: 205/255, blue: 230/255, alpha: 1)
        line.lineWidth = 10
        addChild(line)

        
    }
}
