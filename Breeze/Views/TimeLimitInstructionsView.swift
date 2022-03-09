//  TimeLimitInstructionsView.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/13/21.
//
import SwiftUI
struct TimeLimitInstructionsView: View {
    @State private var timeSelectionIsPresenting = false
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack {
                Spacer()
                Text("**Welcome to Breeze.**")
                    .font(.body).foregroundColor(Color.black)
                    .padding(.bottom, 20)
                Text("We can help you reduce your screen time using positive reinforcement!")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .allowsTightening(true)
                Text("To begin, set a time limit, \nafter which Breeze will notify \nyou to take a break.")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal).padding(.vertical, 15)
                Text("After you’ve hit your limit, \nwe will invite you to play a short game \nto divert your headspace away from your phone.")
                    .font(.body).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal).padding(.top, 10).padding(.bottom, 20)
                Button("Set time limit", action: {timeSelectionIsPresenting.toggle()})
                    .padding()
                    .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
                    .foregroundColor(Color.black)
                    .cornerRadius(6)
                Spacer()
            }
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
