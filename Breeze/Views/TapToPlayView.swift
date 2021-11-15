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
    @State private var userPoints = UserDefaults.standard.getPoints()
    @State private var userStreak =
    UserDefaults.standard.getStreak()
    @State private var numClicks =
    UserDefaults.standard.getNumClicks()
    
    var scene: SKScene {
        let scene = StartingWhirlpoolGameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Way to go! Here's an update on your healthier habits.").font(Font.custom("Baloo2-Regular", size:30)).multilineTextAlignment(.center).padding()
                VStack (spacing: 0, content: {
                    Text("BreezeBucks:  \(userPoints)").font(Font.custom("Baloo2-Regular", size:30).weight(.bold))
                    Divider()
                    Text("Streak:  \(userStreak) days").font(Font.custom("Baloo2-Regular", size:30).weight(.bold))
                    Divider()
                    Text("Est. Time Saved:  \(numClicks) hours").font(Font.custom("Baloo2-Regular", size:30).weight(.bold))
                    Divider()
                }).padding()
                // attribution to Alfredo Hernandez for the icon
                Button(action: {
                    withAnimation {
                        isPresenting.toggle()
                    }
                }, label: {
                    ZStack {
                        Ellipse().scale(0.9)
                            .fill(Color(red: 246/255, green: 228/255, blue: 173/255)).frame(width: 300, height: 150)
                        VStack(spacing: 20) {
                            Image("right-arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .offset(CGSize.init(width: 10, height: 20))
                            
                            Text("Tap to play!").font(Font.custom("Baloo2-Regular", size:30)).foregroundColor(Color.black)
                        }
                        
                    }.frame(width: 300, height: 150)}
                ).padding()
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
