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

class MapGameScene: SKScene {
    var mapTrail = SKSpriteNode(imageNamed: "map dots.png")

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
    
    var boat = SKSpriteNode(imageNamed: "boat2")
    var dock = SKSpriteNode(imageNamed: "dock2")

    let boat_speed = 100
    
    override func didMove(to view: SKView) {
        
        // map reset if necessary (comment out until needed)
        // sets all islands back to lvl 1 (thus "locking" islands 2-5)
        UserDefaults.standard.resetMap()
        
        //background
        self.backgroundColor = UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)
        mapTrail.size = CGSize(width: frame.size.width, height: frame.size.height)
        mapTrail.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(mapTrail)

        island1.size = CGSize(width: island_size, height: island_size)
        island1.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.20)
        island1.name = "island1"
        island1.removeFromParent()
        addChild(island1)
        island1label = SKLabelNode(fontNamed: "Baloo 2")
        // island1 always starts unlocked
        island1label.text = "Island Open"
        if UserDefaults.standard.islandGetLevel(value: 1) > 1 {
            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + "/5"
        }
        island1label.fontSize = 10
        island1label.fontColor = SKColor.black
        island1label.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.20 - island_size*0.5)
        addChild(island1label)

        
        island2.size = CGSize(width: island_size, height: island_size)
        island2.position = CGPoint(x: frame.size.width * 0.25, y: frame.size.height * 0.35)
        island2.name = "island2"
        island2.removeFromParent()
        addChild(island2)
        island2label = SKLabelNode(fontNamed: "Baloo 2")
        if UserDefaults.standard.islandGetLevel(value: 1) >= 5 {
            island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + "/5"
            island2.alpha = 1
        } else {
            island2label.text = "Island Locked"
            island2.alpha = 0.4
        }
        island2label.fontSize = 10
        island2label.fontColor = SKColor.black
        island2label.position = CGPoint(x: frame.size.width * 0.25, y: frame.size.height * 0.35 - island_size*0.5)
        addChild(island2label)
        
        island3.size = CGSize(width: island_size, height: island_size)
        island3.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.50)
        island3.name = "island3"
        island3.removeFromParent()
        addChild(island3)
        island3label = SKLabelNode(fontNamed: "Baloo 2")
        if UserDefaults.standard.islandGetLevel(value: 2) >= 5 {
            island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + "/5"
            island3.alpha = 1
        } else {
            island3label.text = "Island Locked"
            island3.alpha = 0.4
        }
        island3label.fontSize = 10
        island3label.fontColor = SKColor.black
        island3label.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.50 - island_size*0.5)
        addChild(island3label)
        
        island4.size = CGSize(width: island_size, height: island_size)
        island4.position = CGPoint(x: frame.size.width * 0.25, y: frame.size.height * 0.65)
        island4.name = "island4"
        island4.removeFromParent()
        addChild(island4)
        island4label = SKLabelNode(fontNamed: "Baloo 2")
        if UserDefaults.standard.islandGetLevel(value: 3) >= 5 {
            island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + "/5"
            island4.alpha = 1
        } else {
            island4label.text = "Island Locked"
            island4.alpha = 0.4
        }
        island4label.fontSize = 10
        island4label.fontColor = SKColor.black
        island4label.position = CGPoint(x: frame.size.width * 0.25, y: frame.size.height * 0.65 - island_size*0.5)
        addChild(island4label)
        
        island5.size = CGSize(width: island_size, height: island_size)
        island5.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.80)
        island5.name = "island5"
        island5.removeFromParent()
        addChild(island5)
        island5label = SKLabelNode(fontNamed: "Baloo 2")
        if UserDefaults.standard.islandGetLevel(value: 4) >= 5 {
            island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + "/5"
            island5.alpha = 1
        } else {
            island5label.text = "Island Locked"
            island5.alpha = 0.4
        }
        island5label.fontSize = 10
        island5label.fontColor = SKColor.black
        island5label.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.80 - island_size*0.5)
        addChild(island5label)
        
        boat.position = CGPoint(x: frame.size.width * 0.2 + 30, y: frame.minY + 30)
        boat.size = CGSize(width: 70 * 0.5, height: 120 * 0.5)
        boat.removeFromParent()
        self.addChild(boat)
        
        dock.position = CGPoint(x: frame.size.width * 0.2 , y: frame.minY)
        dock.size = CGSize(width: 100 * 0.5, height: 300 * 0.5)
        self.addChild(dock)
        
        let instructions1 = SKLabelNode(fontNamed: "Baloo 2")
        instructions1.text = "Tap an island to play! To unlock an island, play all the levels of the previous island on the map."
        instructions1.fontSize = 15
        instructions1.fontColor = SKColor.black
        instructions1.position = CGPoint(x: frame.size.width * 0.30, y: frame.size.height * 0.80)
        instructions1.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructions1.numberOfLines = 4
        instructions1.preferredMaxLayoutWidth = frame.size.width * 0.5
        addChild(instructions1)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = self.nodes(at: location)
                for node in touchedNode {
                    if node.name == "island1" {
                        // no locked check because island1 always starts unlocked
                        UserDefaults.standard.islandLevelUp(value: 1)
                        if UserDefaults.standard.islandGetLevel(value: 1) == 1 {
                            //move boat
                            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + "/5"
                            moveSprite(pointA: dock.position, pointB: island1.position)
                        }
                        else if UserDefaults.standard.islandGetLevel(value: 1) == 5 {
                            // what happens here? user can still play the island?
                            // randomized new levels?
                            island1label.text = "Level: 5/5"
                            if UserDefaults.standard.islandGetLevel(value: 2) == 0 {
                                island2label.text = "Island Open"
                                island2.alpha = 1
                            }
                        } else {
                            island1label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 1)) + "/5"
                        }
                    }
                    
                    if node.name == "island2" {
                        if UserDefaults.standard.islandGetLevel(value: 1) < 5 {
                            shakeSprite(layer: island2, duration: 0.5)
                        }
                        else {
                            UserDefaults.standard.islandLevelUp(value: 2)
                             if UserDefaults.standard.islandGetLevel(value: 2) == 1 {
                            //move boat
                            island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + "/5"
                            moveSprite(pointA: island1.position, pointB: island2.position)
                             }
                            else if  UserDefaults.standard.islandGetLevel(value: 2) == 5 {
                                    island2label.text = "Level: 5/5"
                                    if UserDefaults.standard.islandGetLevel(value: 3) == 0 {
                                        island3label.text = "Island Open"
                                        island3.alpha = 1
                                    }
                                    break
                                }
                            else{
                                island2label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 2)) + "/5"
                            }
                        }
                    }
                    
                    if node.name == "island3" {
                        if UserDefaults.standard.islandGetLevel(value: 2) < 5 {
                            shakeSprite(layer: island3, duration: 0.5)
                        }
                        else {
                            UserDefaults.standard.islandLevelUp(value: 3)
                             if UserDefaults.standard.islandGetLevel(value: 3) == 1 {
                            //move boat
                            island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + "/5"
                            moveSprite(pointA: island2.position, pointB: island3.position)
                             }
                            else if  UserDefaults.standard.islandGetLevel(value: 3) == 5 {
                                    island3label.text = "Level: 5/5"
                                    if UserDefaults.standard.islandGetLevel(value: 4) == 0 {
                                        island4label.text = "Island Open"
                                        island4.alpha = 1
                                    }
                                    break
                                }
                            else{
                                island3label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 3)) + "/5"
                            }
                        }
                    }
                    
                    if node.name == "island4" {
                        if UserDefaults.standard.islandGetLevel(value: 3) < 5 {
                            shakeSprite(layer: island4, duration: 0.5)
                        }
                        else {
                            UserDefaults.standard.islandLevelUp(value: 4)
                             if UserDefaults.standard.islandGetLevel(value: 4) == 1 {
                            //move boat
                            island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + "/5"
                            moveSprite(pointA: island3.position, pointB: island4.position)
                             }
                            else if  UserDefaults.standard.islandGetLevel(value: 4) == 5 {
                                    island4label.text = "Level: 5/5"
                                    if UserDefaults.standard.islandGetLevel(value: 5) == 0 {
                                        island5label.text = "Island Open"
                                        island5.alpha = 1
                                    }
                                    break
                                }
                            else{
                                island4label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 4)) + "/5"
                            }
                        }
                    }
                    
                    if node.name == "island5" {
                        if UserDefaults.standard.islandGetLevel(value: 4) < 5 {
                            shakeSprite(layer: island5, duration: 0.5)
                        }
                        else {
                            UserDefaults.standard.islandLevelUp(value: 5)
                            if UserDefaults.standard.islandGetLevel(value: 5) == 1 {
                            //move boat
                            island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + "/5"
                            moveSprite(pointA: island4.position, pointB: island5.position)
                             }
                            else if  UserDefaults.standard.islandGetLevel(value: 5) == 5 {
                                    island5label.text = "Level: 5/5"
                                }
                            else {
                                island5label.text = "Level: " + String(UserDefaults.standard.islandGetLevel(value: 5)) + "/5"
                            }
                        }
                    }
                }
            }
        }
    
    func moveSprite(pointA: CGPoint, pointB: CGPoint){
        print("in sprite movement")
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
    
    func swap() {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fade(withDuration: 1.0)
        gameScene?.scaleMode = .aspectFill
        scene?.view?.presentScene(gameScene!, transition: transition)
    }
    
}
