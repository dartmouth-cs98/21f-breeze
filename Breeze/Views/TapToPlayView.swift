//
//  TapToPlayScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI
import SpriteKit

struct TapToPlayView: View {
    
    @State private var isPresenting = false
    var scene: SKScene {
        let scene = StartingWhirlpoolGameScene()
        scene.scaleMode = .resizeFill
        return scene
    }

      var body: some View {
        ZStack {
            VStack {
                // attribution to Alfredo Hernandez for the icon
                Button(action: {
                    withAnimation {
                        isPresenting.toggle()
                    }
                }, label: {
                    ZStack {
                        Image("right-arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                            .offset(CGSize.init(width: 10, height: 0))
                        Circle().scale(0.9)
                            .stroke(lineWidth: 10).fill(Color.black)
                        }.frame(width: 130, height: 130)}
                )
                Text("Tap to Play")
                    .font(Font.custom("Baloo2-Bold", size:20))
                    .padding()
            }

          if isPresenting {
            ZStack(alignment: .center) {
                GeometryReader { gp in
                    SpriteView(scene: scene)
                        .frame(width: gp.size.width, height: gp.size.height)
                }.ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
            .transition(.asymmetric(insertion: .opacity, removal: .scale))
          }
        }
      }
}

struct TapToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        TapToPlayView()
    }
}
