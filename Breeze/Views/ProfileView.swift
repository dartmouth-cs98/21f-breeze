//
//  ProfileView.swift
//  Breeze
//
//  Created by Katherine Taylor on 2/9/22.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Binding var isPresenting: Bool
    @State private var timeSelectionIsPresenting = false
    @State private var currTime = UserDefaults.standard.getTime()
    @State private var notificationStreak = UserDefaults.standard.getStreak()
    @State private var currWeekScreenTime = UserDefaults.standard.getCurrentWeekPhoneUsage();
    @State private var prevWeekScreenTime = Int(UserDefaults.standard.getProportionWeekSpent() * Double(UserDefaults.standard.getPreviousWeekPhoneUsage()));
    @State private var percentNotifications = 0;
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
            VStack (alignment: .center) {
                Text("Profile")
                    .font(.title).underline().bold()
                HStack {
                    // Back arrow which takes user back to tapToPlay
                    Button(action: {
                        withAnimation {
                            isPresenting.toggle()
                        }
                    }, label: {
                        // credit IconArchive https://iconarchive.com/show/ios7-icons-by-icons8/arrows-back-icon.html
                        Image("Arrows-Back-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding()
                    })
                    // Change notification time
                    VStack {
                        Text("Breeze notifies you every...")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Button(convertTime(timeInMin: currTime), action: {timeSelectionIsPresenting.toggle()})
                            .padding()
                            .font(.body)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                    }
                        .padding()
                    Spacer()
                }
                    .padding()
                Text("Your Breeze Journey")
                    .font(.title).underline()
                    .multilineTextAlignment(.center)
                // User statistics
                // notification streak
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
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                // screentime percent change
                VStack {
                    if (currWeekScreenTime > prevWeekScreenTime) {
                        Text("Your screentime is up")
                            .font(.body)
                    }
                    else {
                        Text("Your screentime is down")
                            .font(.body)
                    }
                    Text(calculateScreenTimePercent(currWeek: Float(currWeekScreenTime), prevWeek: Float(prevWeekScreenTime)))
                        .font(.headline)
                        .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                        .padding()
                    Text("from last week")
                        .font(.body)
                }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                // notification acceptance percent
                VStack {
                    Text("This week, you accepted")
                        .font(.body)
                    Text(calculatePercentNotificationValue())
                        .font(.headline)
                        .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                        .padding()
                    Text("of notifications")
                        .font(.body)
                }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                // TO DO: button to view statistics
            }
        }.fullScreenCover(isPresented: $timeSelectionIsPresenting,
                          onDismiss: didDismissTimeSelectionView) {
            TimeSelectionView(timeSelectionIsPresenting: self.$timeSelectionIsPresenting)
            
        }
    }
    
    // function to convert time in minutes to a string split into hours and minutes
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
    
    func calculateScreenTimePercent(currWeek: Float, prevWeek: Float) -> String {
        // avoid dividing by 0
        if (prevWeek == 0) {
            return "0%"
        }
        return String(Int(((currWeek - prevWeek)/prevWeek*100))) + "%"
    }
    
    func calculatePercentNotificationValue() -> String {
        // avoid dividing by 0
        if (UserDefaults.standard.getCurrNotificationSends() != 0) {
            percentNotifications = UserDefaults.standard.getCurrNotificationClicks()/UserDefaults.standard.getCurrNotificationSends()
        }
        return String(percentNotifications) + "%"
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
