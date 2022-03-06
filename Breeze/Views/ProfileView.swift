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
    @State private var difficultySelectionIsPresenting = false
    @State private var testingDataIsPresenting = false
    @State private var currTime = UserDefaults.standard.getTime()
    @State private var notificationStreak = UserDefaults.standard.getStreak()
    @State private var currWeekScreenTime = UserDefaults.standard.getCurrentWeekPhoneUsage();
    @State private var prevWeekScreenTime = Int(UserDefaults.standard.getProportionWeekSpent() * Double(UserDefaults.standard.getPreviousWeekPhoneUsage()));
    @State private var currDayScreenTime = UserDefaults.standard.getCurrentDayPhoneUsage();
    @State private var percentNotifications = 0;
    
    var body: some View {
        Color(red: 255/255, green: 255/255, blue: 255/255).ignoresSafeArea()
        ScrollView {
            ZStack {
                VStack (alignment: .center) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isPresenting.toggle()
                            }
                        }, label: {
                            // credit IconArchive https://iconarchive.com/show/ios7-icons-by-icons8/arrows-back-icon.html
                            Image("Arrows-Back-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .padding()
                        })
                        Spacer()
                        Text("Profile")
                            .font(.title).underline().bold()
                        Spacer()
                        Spacer()
                    }
                        .padding()
                        // Change notification time
                        VStack {
                            Text("Breeze notifies you every...")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            Button(minToHourMin(timeInMin: currTime), action: {timeSelectionIsPresenting.toggle()})
                                .padding()
                                .font(.body)
                                .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                        }
                            .padding()
                        Spacer()
                    VStack {
                        Text("Difficulty")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Button(minToHourMin(timeInMin: currTime), action: {timeSelectionIsPresenting .toggle()})
                            .padding()
                            .font(.body)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                    }
                        .padding()
                    Spacer()
                    Text("Your Breeze Journey")
                        .font(.title).underline()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    // User statistics
                    // notification streak
                    VStack {
                        Text("You've accepted")
                            .font(.body)
                            .foregroundColor(.black)
                        Text("\(notificationStreak)")
                            .font(.title3)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                            .foregroundColor(.black)
                        Text("notifications in a row")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    // today's screen time
                    VStack {
                        Text("Today you've spent")
                            .font(.body)
                            .foregroundColor(.black)
                        Text(secondsToHourMin(timeInSec: currDayScreenTime))
                            .font(.title3)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                            .foregroundColor(.black)
                        Text("on your phone")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                        .padding()
                    // screentime percent change
                    VStack {
                        if (currWeekScreenTime > prevWeekScreenTime) {
                            Text("Your screentime is up")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        else {
                            Text("Your screentime is down")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        Text(calculateScreenTimePercent(currWeek: Float(currWeekScreenTime), prevWeek: Float(prevWeekScreenTime)))
                            .font(.title3)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("from last week")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                    // notification acceptance percent
                    VStack {
                        Text("This week, you accepted")
                            .font(.body)
                            .foregroundColor(.black)
                        Text(calculatePercentNotificationValue())
                            .font(.title3)
                            .foregroundColor(Color.init(UIColor(red: 54/255, green: 110/255, blue: 163/255, alpha: 1)))
                            .padding()
                        Text("of notifications")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                        .padding()
//                    Button("FOR TESTING view statistics", action: {testingDataIsPresenting.toggle()})
//                       .padding()
//                       .background(Color.init(UIColor(red: 221/255, green: 247/255, blue: 246/255, alpha: 1)))
//                       .foregroundColor(Color.black)
//                       .cornerRadius(6)
                }
            }
            // full screen cover for changing notification time
            .fullScreenCover(isPresented: $timeSelectionIsPresenting,
                              onDismiss: didDismissTimeSelectionView) {
                TimeSelectionView(timeSelectionIsPresenting: self.$timeSelectionIsPresenting)
            }
            // full screen cover for difficulty selection
//            .fullScreenCover(isPresented: $difficultySelectionIsPresenting,
//                            onDismiss: didDismissTimeSelectionView) {
//                TimeSelectionView(timeSelectionIsPresenting: self.$timeSelectionIsPresenting)
//            }
            
            // full screen cover for viewing temporary testing data
            .fullScreenCover(isPresented: $testingDataIsPresenting,
                              onDismiss: didDismissTimeSelectionView) {
                TempTestingDataView(isPresenting: self.$testingDataIsPresenting)
            }
        }
    }
    
    func secondsToHourMin(timeInSec: Int) -> String {
        var hours = 0
        var mins = 0
        var leftoverTime = timeInSec
        while (leftoverTime >= 3600) {
            leftoverTime -= 3600
            hours += 1
        }
        while (leftoverTime >= 60) {
            leftoverTime -= 60
            mins += 1
        }
        return String(hours) + " hr " + String(mins) + " min"
    }
    
    // function to convert time in minutes to a string split into hours and minutes
    func minToHourMin(timeInMin: Int) -> String {
        print(secondsToHourMin(timeInSec: 3660))
        var hours = 0
        var mins = 0
        var leftoverTime = timeInMin
        while (leftoverTime >= 60) {
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
    
//    func didDismissDifficultySelectionView() {
////        UserDefaults.standard.set(false, forKey: "hasntFinishedSetup")
////        // update the user's notification time
////        currTime = UserDefaults.standard.getTime()
//    }
    
    func didDismissTestingDataView() {
        
    }
}

