//
//  ContentView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import CoreData
import SpriteKit

let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    var scene: SKScene {
            let scene = MapGameScene()
            scene.size = CGSize(width: screenWidth, height: screenHeight)
            scene.scaleMode = .fill
            return scene
        }

        var body: some View {
            SpriteView(scene: scene)
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
        }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
