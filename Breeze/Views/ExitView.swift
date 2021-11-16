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
                 Button("Collect Your BreezeBucks!", action: goToTapToPlay)
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()

                }
                    .buttonStyle(.bordered)
            }
        }
    
    func goToTapToPlay () {
        UserDefaults.standard.setPoints(value: 5)
        if (UserDefaults.standard.getLastDatePlayed() >= 1) {
            UserDefaults.standard.setLastDatePlayedToToday()
            if (UserDefaults.standard.getDaysFromLastPlay() == 1) {
                UserDefaults.standard.setStreak(value: UserDefaults.standard.getStreak() + 1)
            }
        }
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(true, forKey: "hasntFinishedGame")
        exitViewIsPresenting.toggle()
    }
}


