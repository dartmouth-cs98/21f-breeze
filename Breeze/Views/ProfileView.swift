//
//  ProfileView.swift
//  Breeze
//
//  Created by Katherine Taylor on 2/9/22.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var timeSelectionIsPresenting = false
    @State private var currTime = UserDefaults.standard.getTime()
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack (alignment: .center) {
                // TO DO: back arrow -- clicking on takes to.... tap to play?
                Text("Breeze notifies you every...")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Button(convertTime(timeInMin: currTime), action: {timeSelectionIsPresenting.toggle()})
                    .padding()
                    .font(.body)
                    .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                Text("Your Breeze Journey")
                    .font(.title).underline()
                    .multilineTextAlignment(.center)
                VStack {
                    Text("You've accepted")
                        .font(.body)
                    Text("temp")
                        .font(.headline)
                        .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                        .padding()
                    Text("notifications in a row")
                        .font(.body)
                }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                // TO DO: statistics with userDefaults stuff and outlined
                // TO DO: button to view statistics
            }
        }.fullScreenCover(isPresented: $timeSelectionIsPresenting,
                          onDismiss: didDismissTimeSelectionView) {
            TimeSelectionView(timeSelectionIsPresenting: self.$timeSelectionIsPresenting)
            
        }
    }
    
    func convertTime(timeInMin: Int) -> String {
        var hours = 0
        var mins = 0
        var leftoverTime = timeInMin
        while (leftoverTime > 60) {
            leftoverTime -= 60
            hours += 1
        }
        mins = leftoverTime
        return String(hours) + " hr " + String(mins) + " min"
    }
    
    func didDismissTimeSelectionView() {
        UserDefaults.standard.set(false, forKey: "hasntFinishedSetup")
        // update the user's notification time
        currTime = UserDefaults.standard.getTime()
    }
}

//@available(iOS 15.0, *)
//struct EndOfSetUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        EndOfSetUpView()
//    }
//}
