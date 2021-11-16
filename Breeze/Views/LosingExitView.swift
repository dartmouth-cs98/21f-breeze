//
//  LosingExitView.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/15/21.
//


import SwiftUI

struct LosingExitView: View {
    
    @Binding var losingExitViewIsPresenting: Bool
    
    var body: some View {
        ZStack {
            Color.init(UIColor(named: "LaunchScreenBackground")!)
            VStack {
                Text("Uh-oh! Looks like you misnavigated...")
                    .font(Font.custom("Baloo2-Bold", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Want to try again?")
                    .font(Font.custom("Baloo2-Bold", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Button(action: tryAgain) {
                    Text("Yes please!").font(Font.custom("Baloo2-Regular", size:20))
                   .background(Color.init(UIColor(red: 100/255, green: 173/255, blue: 218/255, alpha: 1)))
                   .foregroundColor(Color.black)
                   .cornerRadius(6)
                   .padding()
                }
                Button(action: goToTapToPlay) {
                    Text("No, Please Take Me Home").font(Font.custom("Baloo2-Regular", size:20))
                   .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                   .foregroundColor(Color.black)
                   .cornerRadius(6)
                   .padding()
                }
            }
        }
    }
    
    func goToTapToPlay () {
        losingExitViewIsPresenting.toggle()
    }
    
    func tryAgain () {
        UserDefaults.standard.set(true, forKey: "hasntLostGame")
    }
}


