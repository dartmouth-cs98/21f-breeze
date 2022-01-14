//
//  TimeLimitInstructionsView.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/13/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct TimeLimitInstructionsView: View {
    @State private var timeSelectionIsPresenting = false
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Welcome to Breeze.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .padding()
                Text("We can help you reduce your screen time using positive reinforcement!")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("To begin, set a time limit, after which Breeze will notify you to take a break.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("After you’ve hit your limit, we will invite you to play a short game to change your headspace and divert your attention to a more mindful place.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Set time limit", action: {timeSelectionIsPresenting.toggle()})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                    .padding()
                Spacer()
            }.buttonStyle(.bordered)
        }.fullScreenCover(isPresented: $timeSelectionIsPresenting,
                          onDismiss: didDismissTimeSelectionView) {
            TimeSelectionView(timeSelectionIsPresenting: self.$timeSelectionIsPresenting)
            
        }
        
    }
    
    func didDismissTimeSelectionView() {
        UserDefaults.standard.set(false, forKey: "hasntFinishedSetup")
    }
}

@available(iOS 15.0, *)
struct TimeLimitInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLimitInstructionsView()
    }
}
