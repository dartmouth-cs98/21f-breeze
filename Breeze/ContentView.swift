//
//  ContentView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import CoreData
import SpriteKit


struct ContentView: View {
    
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
        
    }
    
    var body: some View {
        
        GeometryReader { gp in
            SpriteView(scene: scene)
                .frame(width: gp.size.width, height: gp.size.height)
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
