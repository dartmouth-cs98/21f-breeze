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
                Text("Welcome to Breeze.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .padding()
                Text("Continue set up by setting a time limit, after which Breeze will notify you when you use your selected apps.")
                    .font(Font.custom("Baloo2-Regular", size:20))
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Set time limit", action: {timeSelectionIsPresenting.toggle()})
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .padding()
                Spacer()
            }
            .buttonStyle(.bordered)
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
