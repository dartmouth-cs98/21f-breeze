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
    let usageUpdatesLog = Logger.init(subsystem: "edu.dartmouth.Breeze", category: "UsageUpdates")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
            
        // set this class as the notification delegate
        userNotificationCenter.delegate = self

        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        application.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()

        if (UIApplication.shared.isRegisteredForRemoteNotifications) {
            log.notice("This application on this device is registered for remote notifications")
        } else {
            log.notice("This application on this device is NOT registered for remote notifications")
        }

        let (quote, author) = getRandomQuote()
        UserDefaults.standard.setQuote(value: quote)
        UserDefaults.standard.setAuthor(value: author)
            
        return true
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        log.notice("Phone is locking")
        userNotificationCenter.removeAllPendingNotificationRequests()
        checkPhoneUsageBeforeLocking()
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        log.notice("Phone is unlocking")
        log.notice("Current phone usage at unlock: \(UserDefaults.standard.getCurrentPhoneUsage())")
        
        // make sure nothing is scheduled
        userNotificationCenter.removeAllPendingNotificationRequests()
        // userNotificationCenter.removeAllDeliveredNotifications()
        log.notice("Your current streak at unlock: \(UserDefaults.standard.getStreak())")
        
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
        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
        usageUpdatesLog.notice("Checking phone usage before locking and updating statistics")
        // if date has changed, store previous data and reset current day usage (thus the time interval we are looking at now will be added to the new day)
        UserDefaults.standard.checkDayRollover()
        
        // add interval
        if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
            usageUpdatesLog.notice("Protected data was previously available - adding this time interval to total phone usage")
            UserDefaults.standard.addIntervalToCurrentPhoneUsage()
        }
        // don't add interval
        else {
            usageUpdatesLog.notice("Protected data was not previously available - time interval not captured")
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
                    self.usageUpdatesLog.notice("Time since notification: \(timeSinceNotification)")
                    
                    // not only did they ignore that last notification, but they've been on their phone for longer than their time limit since we sent that notification *double-oof*
                    if (timeSinceNotification > (UserDefaults.standard.getTime() * 60)) {
                        // send them another notification when they unlock their phone the next time
                        UserDefaults.standard.setSendNotificationOnUnlock(value: true)
                        // set their current phone usage to 0 (since we've already planned to send them an immediate notification when they next start using their phone)
                        UserDefaults.standard.resetCurrentPhoneUsage()
                        self.usageUpdatesLog.notice("User is above their chosen time limit, will send a notification to play Breeze next time they open their phone")
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
                self.usageUpdatesLog.notice("User is above their chosen time limit, will send a notification to play Breeze next time they open their phone")
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
        log.notice("User Info: \(String(describing: userInfo))")
        completionHandler([])
    }

    //NOTIFICATION CLICKED
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        log.notice("\(String(describing: userInfo))")
        //TO-DO: HANDLE NOTIFICATION CLICKS - tap, snooze, decline, and (maybe) adjust Breeze settings button. And, add statistics for this.
        switch response.actionIdentifier {
            case "SNOOZE_ACTION":
                log.notice("Snooze option selected from notification")
                UserDefaults.standard.snoozeCurrentPhoneUsage()
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
                UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
                UserDefaults.standard.addNotificationSnooze()
                scheduleNotification()
            case "EDIT_TIME_ACTION":
                log.notice("Edit time selected from notification")
                @AppStorage("hasntFinishedSetup") var hasntFinishedSetup: Bool = true
                @AppStorage("hasntExitedEndOfSetUpView") var hasntExitedEndOfSetUpView: Bool = true
                @AppStorage("hasntBeenPromptedForLocationAuthorization") var hasntBeenPromptedForLocationAuthorization: Bool = true
                        
            case UNNotificationDefaultActionIdentifier,
                   UNNotificationDismissActionIdentifier:
                 // The user clicked the notification, so reset current phone usage and update clicked statistics
                log.notice("User clicked notification")
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
            log.notice("Over time limit - Sending notification immediately")
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        } else {
            log.notice("Notification scheduled to deliver in \((UserDefaults.standard.getTime() * 60) - UserDefaults.standard.getCurrentPhoneUsage()) seconds")
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
      
    
    func applicationWillResignActive(_ application: UIApplication) {
        log.notice("Will resign active")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        log.notice("Will become active")
    }
    
    /*
    func applicationWillTerminate(_ application: UIApplication) {
        // cancel notification
        check phone usage
        // cancel
    }
     */
    
    func getRandomQuote() -> (String, String) {
        let allQuotes = [ "It is not the mountain we conquer, but ourselves", "If we all did the things we are capable of doing, we would literally astound ourselves", "“Breath is the power behind all things . . . I breathe in and know that good things will happen", "A year from now you may wish you had started today", "Yesterday is gone. Tomorrow has not yet come. We have only today. Let us begin"]
        let allAuthors = ["Sir Edmond Hillary", "Thomas Edison", "Tao Porchon-Lynch", "Karen Lamb", "Mother Teresa"]
        
        let randInt1 = Int.random(in: 0..<allQuotes.count)
        let randInt2 = Int.random(in: 0..<allQuotes.count)
        let randInt3 = Int.random(in: 0..<allQuotes.count)
        let randInt4 = Int.random(in: 0..<allQuotes.count)
        let randInt5 = Int.random(in: 0..<allQuotes.count)
        let randInt6 = Int.random(in: 0..<allQuotes.count)
        let randInt7 = Int.random(in: 0..<allQuotes.count)
        let randInt8 = Int.random(in: 0..<allQuotes.count)
        let randInt9 = Int.random(in: 0..<allQuotes.count)
        let randInt10 = Int.random(in: 0..<allQuotes.count)
        let randInt11 = Int.random(in: 0..<allQuotes.count)
        let randInt12 = Int.random(in: 0..<allQuotes.count)
        let randInt13 = Int.random(in: 0..<allQuotes.count)
        let randInt14 = Int.random(in: 0..<allQuotes.count)
        let randInt15 = Int.random(in: 0..<allQuotes.count)
        print(randInt)
        print(randInt2)
        print(randInt3)
        print(randInt4)
        print(randInt5)
        print(randInt6)
        print(randInt7)
        print(randInt8)
        print(randInt9)
        print(randInt10)
        print(randInt11)
        print(randInt12)
        print(randInt13)
        print(randInt14)
        print(randInt15)
        
        let quote = allQuotes[randInt]
        let author = allAuthors[randInt]
        return (quote, author)
    }
}


