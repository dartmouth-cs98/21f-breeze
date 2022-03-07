//
//  TapToPlayScreen.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI
import SpriteKit

struct TapToPlayView: View {
    @Binding var profileViewIsPresenting: Bool
    @State private var isPresenting = false
    @AppStorage("hasntFinishedGame") var hasntFinishedGame: Bool = true
    @AppStorage("hasntLostGame") var hasntLostGame: Bool = true
    @State private var userStreak =
    UserDefaults.standard.getStreak()
    @State private var numClicks =
    UserDefaults.standard.getNumClicks()
    

    var scene: SKScene {
        let scene = MapGameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack {
                // access to profile page
                HStack {
                    Button(action: {
                        withAnimation() {
                            profileViewIsPresenting.toggle()
                        }
                    }, label: {
                        // credit PNGITEM https://www.pngitem.com/middle/mJiRJh_profile-icon-png-transparent-profile-picture-icon-png/
                        Image("profile-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding()
                    })
                    Spacer()
                }
                // these spacers may seem redundant, but they are keeping tap to play button roughly centered
                Spacer()
                Spacer()
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
                // these spacers may seem redundant, but they are keeping tap to play button roughly centered
                Spacer()
                Spacer()
                Spacer()
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
                        LosingExitView(losingExitViewIsPresenting: $isPresenting).transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                    }
                } else {
                    ExitView(exitViewIsPresenting: $isPresenting).transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
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

