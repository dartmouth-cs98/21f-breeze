//
//  TapToPlayScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI
import SpriteKit

@available(iOS 15.0, *)
struct TapToPlayView: View {
    
    @State private var isPresenting = false
    @AppStorage("hasntFinishedGame") var hasntFinishedGame: Bool = true
    @AppStorage("hasntLostGame") var hasntLostGame: Bool = true
    @State private var userStreak =
    UserDefaults.standard.getStreak()
    @State private var numClicks =
    UserDefaults.standard.getNumClicks()
    

    var scene: SKScene {
        //let scene = StartingWhirlpoolGameScene()
        let scene = MapGameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack {
                // NOTE: keeping these for now so I can use for reference with profile screen
//                Text("Way to go! Here's an update on your healthier habits.").font(Font.custom("Baloo2-Regular", size:30)).multilineTextAlignment(.center).padding()
//                VStack (spacing: 0, content: {
//                    Divider()
//                    Text("Streak:  \(userStreak) days").font(Font.custom("Baloo2-Regular", size:30).weight(.bold))
//                    Divider()
//                    Text("Est. Time Saved:  \(numClicks) hours").font(Font.custom("Baloo2-Regular", size:30).weight(.bold))
//                    Divider()
//                }).padding()
                // attribution to Alfredo Hernandez for the icon
                Button(action: {
                    withAnimation {
                        UserDefaults.standard.set(true, forKey: "hasntLostGame")
                        UserDefaults.standard.set(true, forKey: "hasntFinishedGame")
                        isPresenting.toggle()
                    }
                }, label: {
                    ZStack {
                        Ellipse().scale(0.9)
                            .fill(Color(red: 221/255, green: 247/255, blue: 246/255)).frame(width: 300, height: 150)
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
//                  NOTE: keeping these for now in case I want to easily uncomment for testing set up flow
//                Button("Go back to setup", action: {restartSetup()})
//                    .font(Font.custom("Baloo2-Regular", size:30))
//                    .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
//                    .foregroundColor(Color.black)
//                    .cornerRadius(6)
//                    .buttonStyle(.bordered)
            }
          if isPresenting {
            ZStack(alignment: .center) {
                Color(red: 204/255, green: 238/255, blue: 248/255).ignoresSafeArea()
                if (hasntFinishedGame) {
                    if (hasntLostGame) {
                        GeometryReader { gp in
                            SpriteView(scene: scene)
                                .frame(width: gp.size.width, height: gp.size.height)
                        }.ignoresSafeArea()
                    } else {
                        LosingExitView(losingExitViewIsPresenting: $isPresenting)
                    }
                } else {
                    ExitView(exitViewIsPresenting: $isPresenting)
                }
                
  
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
            .transition(.asymmetric(insertion: .opacity, removal: .scale))
            }
        }
    }
    
    func restartSetup() {
        UserDefaults.standard.set(false, forKey: "appsToTrackHaveBeenSelected")
        UserDefaults.standard.set(true, forKey: "hasntExitedEndOfSetUpView")
        UserDefaults.standard.set(true, forKey: "hasntFinishedSetup")
        
    }
}

