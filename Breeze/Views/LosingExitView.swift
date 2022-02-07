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
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack {
                Text("Uh-oh! Looks like you misnavigated...")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Want to try again?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Yes please!", action: {tryAgain()})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                Button("No thanks. Take me home.", action: {goToTapToPlay()})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
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


