//
//  IslandSpriteNode.swift
//  Breeze
//
//  Created by Laurel Dernbach on 1/22/22.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI

class Island: SKSpriteNode {
    
    /*var count:Int = 0*/
    var image: String
    var islandName: String
    var level: Int
    var locked: Bool

    init(iNamed: String, islandName: String) {
       
        self.image = iNamed
        self.islandName = islandName
        self.level = 1
        self.locked = true
        let texture = SKTexture(imageNamed: iNamed)

        //Designated initializer
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        // herer say "if locked" display one way, else display in full"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    // func to inclease level
    // func to lock
    
    
}
