//
//  LosingExitView.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/15/21.
//


import SwiftUI
@available(iOS 15.0, *)
struct LosingExitView: View {
    
    @Binding var losingExitViewIsPresenting: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Uh-oh! Looks like you misnavigated...")
                    .font(Font.custom("Baloo2-Regular", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Want to try again?")
                    .font(Font.custom("Baloo2-Regular", size:20)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Yes please!", action: {tryAgain()})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
                Button("No thanks. Take me home.", action: {goToTapToPlay()})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
            }.buttonStyle(.bordered)
        }
    }
    
    func goToTapToPlay () {
        losingExitViewIsPresenting.toggle()
    }
    
    func tryAgain () {
        UserDefaults.standard.set(true, forKey: "hasntLostGame")
    }
}


