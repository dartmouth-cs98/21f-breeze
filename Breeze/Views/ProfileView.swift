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
    @State private var notificationStreak = UserDefaults.standard.getStreak()
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack (alignment: .center) {
                Text("Your Breeze Journey")
                    .font(.title).underline()
                    .multilineTextAlignment(.center)
                ScrollView {
                // TO DO: back arrow -- clicking on takes to.... tap to play?
                Text("Breeze notifies you every...")
                    .font(.headline)
                    .multilineTextAlignment(.center).padding(.top, 25)
                Button(convertTime(timeInMin: currTime), action: {timeSelectionIsPresenting.toggle()})
                    .padding()
                    .font(.body)
                    .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1))).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                
                
                LazyVStack {
                    Text("Notication Stats")
                        .bold()
                        .padding(.vertical, 20)
                    VStack {
                        Text("You've accepted")
                            .font(.body)
                        Text("\(notificationStreak)")
                            .font(.headline)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("notifications in a row")
                            .font(.body)
                    }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 1))
                    
                    VStack {
                        Text("We've sent you")
                            .font(.body)
                        Text("\(notificationStreak)")
                            .font(.headline)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("notifications")
                            .font(.body)
                    }
                        .padding()
                        .padding(.horizontal, 20)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    VStack {
                        Text("You've snoozed")
                            .font(.body)
                        Text("\(notificationStreak)")
                            .font(.headline)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("notifications")
                            .font(.body)
                    }
                        .padding().padding(.horizontal, 20)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    Text("Screen Time").bold().padding(.vertical, 20)
                    VStack {
                        Text("Your screen time \nthis week:")
                            .font(.body)
                            .multilineTextAlignment(.center)
                        Text("\(notificationStreak)")
                            .font(.headline)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("minutes")
                            .font(.body)

                    }
                        .padding().padding(.horizontal, 15)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    VStack {
                        Text("Your screen time \nlast week:")
                            .font(.body)
                            .multilineTextAlignment(.center)
                        Text("\(notificationStreak)")
                            .font(.headline)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("minutes")
                            .font(.body)

                    }
                        .padding().padding(.horizontal, 15)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    
                
                }}
                
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

struct EndOfSetUpView_Previews: PreviewProvider {
    static var previews: some View {
       ProfileView()
    }
}
