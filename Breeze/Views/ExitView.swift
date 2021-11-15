//
//  ExitView.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/24/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct ExitView: View {
    
    @Binding var exitViewIsPresenting: Bool
    
    var body: some View {
        ZStack {
            Color.init(UIColor(named: "LaunchScreenBackground")!)
            VStack {
                Text("Thanks for playing, enjoy your day!")
                    .font(Font.custom("Baloo2-Bold", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                 Button("Collect Your Point!", action: goToTapToPlay)
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .padding()

                }
                    .buttonStyle(.bordered)
            }
        }
    
    func goToTapToPlay () {
        UserDefaults.standard.setPoints(value: UserDefaults.standard.getPoints() + 5)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(true, forKey: "hasntFinishedGame")
        exitViewIsPresenting.toggle()
    }
}


