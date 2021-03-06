//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import UserNotifications
import BackgroundTasks
import UIKit
import Foundation
import OSLog
import os

@main
struct BreezeApp: App {
    
    @AppStorage("hasntFinishedSetup") var hasntFinishedSetup: Bool = true
    @AppStorage("hasntExitedEndOfSetUpView") var hasntExitedEndOfSetUpView: Bool = true
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    var body: some Scene {
        
        
        WindowGroup {
              if hasntExitedEndOfSetUpView {
                  if hasntFinishedSetup {
                      TimeLimitInstructionsView()
                  } else {
                      InstructionsView()
                  }
                
              } else {
                ContentView()
              }
        }
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let backgroundTaskID = "com.breeze.CheckPhoneUsage"
    let gcmMessageIDKey = "gcm.message_id"
    let log = Logger.init(subsystem: "edu.dartmouth.Breeze", category: "AppDelegate")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
            
        // set this class as the notification delegate
        userNotificationCenter.delegate = self

        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        application.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()

        let (quote, author) = getRandomQuote()
        UserDefaults.standard.setQuote(value: quote)
        UserDefaults.standard.setAuthor(value: author)
            
        return true
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        userNotificationCenter.removeAllPendingNotificationRequests()
        checkPhoneUsageBeforeLocking()
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        // make sure nothing is scheduled
        userNotificationCenter.removeAllPendingNotificationRequests()
        // userNotificationCenter.removeAllDeliveredNotifications()
        
        if (UserDefaults.standard.getCurrentPhoneUsage() >= (UserDefaults.standard.getTime() * 60) || UserDefaults.standard.getSendNotificationOnUnlock()) {
            scheduleNotification(overTimeLimit: true, identity: "overTimeLimit") // make it for 5 seconds
            UserDefaults.standard.addIntervalToCurrentPhoneUsage()
            UserDefaults.standard.resetCurrentPhoneUsage()
        }
        scheduleNotification()
        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
        UserDefaults.standard.checkDayRollover()
        UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
        userNotificationCenter.getPendingNotificationRequests { (notifications) in
            print("\(notifications)")
        }
    }

    func checkPhoneUsageBeforeLocking() {
        var countPendingNotifications = 0
        //get num pending notifications and decrease num sent by that count (because they will not actually send!)
        userNotificationCenter.getPendingNotificationRequests {(notificationRequests) in
            countPendingNotifications = notificationRequests.count
            UserDefaults.standard.decreaseNotificationsSent(value: countPendingNotifications)
        }
        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
        // if date has changed, store previous data and reset current day usage (thus the time interval we are looking at now will be added to the new day)
        UserDefaults.standard.checkDayRollover()
        
        // add interval
        if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
            UserDefaults.standard.addIntervalToCurrentPhoneUsage()
        }
        UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
        
        var count = 0
        userNotificationCenter.getDeliveredNotifications { (notifications) in
            count = notifications.count
            print("outstanding notification count: \(count)")
            if (count > 0) {
                // if there is at least one delivered notification when locking, then a notification was ignored -> reset streak
                UserDefaults.standard.resetStreak()
                
                // user is above time limit and there is an outstanding notification (aka they ignored the notification *sad face*)
                if(UserDefaults.standard.isAboveTimeLimit()) {
                    let timeSinceNotification = UserDefaults.standard.getCurrentPhoneUsage() - (UserDefaults.standard.getTime() * 60)
                    
                    // not only did they ignore that last notification, but they've been on their phone for longer than their time limit since we sent that notification *double-oof*
                    if (timeSinceNotification > (UserDefaults.standard.getTime() * 60)) {
                        // send them another notification when they unlock their phone the next time
                        UserDefaults.standard.setSendNotificationOnUnlock(value: true)
                        // set their current phone usage to 0 (since we've already planned to send them an immediate notification when they next start using their phone)
                        UserDefaults.standard.resetCurrentPhoneUsage()

                    }
                    // they've been on their phone less than their time limit since we sent them that last notification *better, but still not admirable behavior on their part*
                    else {
                        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
                        // keep track of amount of time they've been using their phone since that notification, rather than reseting all the way to zero
                        UserDefaults.standard.setCurrentPhoneUsage(value: timeSinceNotification)
                    }
                }
            }
            //no outstanding notification and above time limit (this would be the case if they hit their time limit right when they lock their phone)
            else if (UserDefaults.standard.isAboveTimeLimit()) {
                // send them a notification right when they open their phone
                UserDefaults.standard.setSendNotificationOnUnlock(value: true)
                // set their current phone usage to 0 (since we've already planned to send them an immediate notification when they next start using their phone)
                UserDefaults.standard.resetCurrentPhoneUsage()
            }
            // no outstanding notifications and below time limit :)
            else {
                UserDefaults.standard.setSendNotificationOnUnlock(value: false)
            }
        }
    }
    

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([])
    }

    //NOTIFICATION CLICKED
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        //TO-DO: HANDLE NOTIFICATION CLICKS - tap, snooze, decline, and (maybe) adjust Breeze settings button. And, add statistics for this.
        switch response.actionIdentifier {
            case "SNOOZE_ACTION":
                UserDefaults.standard.snoozeCurrentPhoneUsage()
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
                UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
                UserDefaults.standard.addNotificationSnooze()
                scheduleNotification()
            case "EDIT_TIME_ACTION":
                @AppStorage("hasntFinishedSetup") var hasntFinishedSetup: Bool = true
                @AppStorage("hasntExitedEndOfSetUpView") var hasntExitedEndOfSetUpView: Bool = true
                @AppStorage("hasntBeenPromptedForLocationAuthorization") var hasntBeenPromptedForLocationAuthorization: Bool = true
                        
            case UNNotificationDefaultActionIdentifier,
                   UNNotificationDismissActionIdentifier:
                 // The user clicked the notification, so reset current phone usage and update clicked statistics
    
                UserDefaults.standard.incrementStreak()
                UserDefaults.standard.addNotificationClick()
                UserDefaults.standard.resetSnoozesCurrPeriod()
                UserDefaults.standard.resetCurrentPhoneUsage()
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
                UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
            default:
                break
        }
        completionHandler()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                self.log.error("Error: \(String(describing: error))")
            }
        }
    }
    
    func formatTimeLimit() -> String {
        let totalMinutes = UserDefaults.standard.getTime()
        let hours = Int(totalMinutes / 60)
        let minutes = totalMinutes - (hours * 60)
        
        var string = ""
        if minutes > 0 && hours > 0 {
            string = String(hours) + " hour and " + String(minutes) + " minute"
        }else if minutes == 0 && hours > 0 {
            string = String(hours) + " hour"
        }else if hours == 0 {
            string = String(totalMinutes) + " minute"
        }
        return string
    }
    
    func scheduleNotification(overTimeLimit: Bool = false, identity: String = "scheduled") {
        UserDefaults.standard.addNotificationSent()
        // Define the custom actions.
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze for 15 minutes",
                                                options: [])
        let changeTimeSettingsOption = UNNotificationAction(identifier: "EDIT_TIME_ACTION",
                                                            title: "Edit Time",
                                                            options: [.foreground])
        
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "OVER_TIME_LIMIT",
              actions: [snoozeAction, changeTimeSettingsOption],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        // Register the notification type.
        self.userNotificationCenter.setNotificationCategories([meetingInviteCategory])

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "You've gone over your " + formatTimeLimit() + " limit."
        notificationContent.body = "Click to take a break with Breeze"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.categoryIdentifier = "OVER_TIME_LIMIT"
        
        if let url = Bundle.main.url(forResource: "dune",
                                     withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        var trigger: UNNotificationTrigger
        
        if (overTimeLimit) {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(((UserDefaults.standard.getTime() * 60) - UserDefaults.standard.getCurrentPhoneUsage())), repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: identity,
                                            content: notificationContent,
                                            trigger: trigger)
        self.userNotificationCenter.add(request) { (error) in
            if let error = error {
                self.log.error("Notification error: \(String(describing: error))")
            }
        }
    }
    
    func getRandomQuote() -> (String, String) {
        let allQuotes = [ "It is not the mountain we conquer, but ourselves", "If we all did the things we are capable of doing, we would literally astound ourselves", "Breath is the power behind all things . . . I breathe in and know that good things will happen", "A year from now you may wish you had started today", "Yesterday is gone. Tomorrow has not yet come. We have only today. Let us begin"]
        let allAuthors = ["Sir Edmund Hillary", "Thomas Edison", "Tao Porchon-Lynch", "Karen Lamb", "Mother Teresa"]
        
        let randInt = Int.random(in: 0..<allQuotes.count)
        
        let quote = allQuotes[randInt]
        let author = allAuthors[randInt]
        return (quote, author)
    }
}


