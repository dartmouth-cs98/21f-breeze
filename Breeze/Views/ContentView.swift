//
//  ContentView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import CoreData
import SpriteKit


@available(iOS 15.0, *)
struct ContentView: View {
    
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    @State var familyPickerView = FamilyActivityPickerView()
    @State private var showModal = false
    
    @ViewBuilder
    var body: some View {
        ZStack {
            
            GeometryReader { gp in
                SpriteView(scene: scene)
                    .frame(width: gp.size.width, height: gp.size.height)
            }.ignoresSafeArea()
            familyPickerView
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
