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
import CoreLocation
import OSLog
import os

@available(iOS 15.0, *)

@main
struct BreezeApp: App {
    
    @AppStorage("hasntFinishedSetup") var hasntFinishedSetup: Bool = true
    @AppStorage("hasntExitedEndOfSetUpView") var hasntExitedEndOfSetUpView: Bool = true
    @AppStorage("hasntBeenPromptedForLocationAuthorization") var hasntBeenPromptedForLocationAuthorization: Bool = true
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    var body: some Scene {
        
        
        WindowGroup {
              if hasntExitedEndOfSetUpView {
                  if hasntFinishedSetup {
                      TimeLimitInstructionsView()
                  } else {
                      if hasntBeenPromptedForLocationAuthorization {
                          LocationAuthorizationView()
                      } else {
                          InstructionsView()
                      }
                      
                  }
                
              } else {
                ContentView()
              }
        }
        
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    let backgroundTaskID = "com.breeze.CheckPhoneUsage"
    let gcmMessageIDKey = "gcm.message_id"
    let log = Logger.init(subsystem: "edu.dartmouth.Breeze", category: "AppDelegate")
    let usageUpdatesLog = Logger.init(subsystem: "edu.dartmouth.Breeze", category: "UsageUpdates")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
            
        // set this class as the notification delegate
        userNotificationCenter.delegate = self
            
        //request authorization to use notifications
        //self.requestNotificationAuthorization()
            
        // request authorization to track updates
        locationManager.delegate = self
        // locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startMonitoringVisits()
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        application.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()

        if (UIApplication.shared.isRegisteredForRemoteNotifications) {
            log.notice("This application on this device is registered for remote notifications")
        } else {
            log.notice("This application on this device is NOT registered for remote notifications")
        }

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
        userNotificationCenter.removeAllPendingNotificationRequests()
        userNotificationCenter.removeAllDeliveredNotifications()
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
    
    // location/visit checks
    func checkPhoneUsageDuringLocationUpdate() {
        usageUpdatesLog.notice("Location/Visit Update - checking phone usage and updating statistics")
        // if date has changed, store previous data and reset current day usage (thus the time interval we are looking at now will be added to the new day)
        UserDefaults.standard.checkDayRollover()
        
        // if phone is unlocked
        if UIApplication.shared.isProtectedDataAvailable {
            usageUpdatesLog.notice("Protected data is available")
            // if phone was unlocked at last check -> add this interval to current phone usage
            if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
                usageUpdatesLog.notice("Protected data was previously available - adding this time interval to total phone usage")
                UserDefaults.standard.addIntervalToCurrentPhoneUsage()
            }
            // phone was locked during last check
            else {
                usageUpdatesLog.notice("Protected data was not previously available - user started using their phone during this time interval")
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
            }
            
            // if the user is above their time limit
            if (UserDefaults.standard.isAboveTimeLimit()) {
                usageUpdatesLog.notice("User is above their chosen time limit,  notification should have been sent to play Breeze")
                let timeSinceNotification = UserDefaults.standard.getCurrentPhoneUsage() - (UserDefaults.standard.getTime() * 60)
                UserDefaults.standard.setCurrentPhoneUsage(value: timeSinceNotification)
            }
        }
        // phone is locked
        else {
            usageUpdatesLog.notice("Protected data is not available")
            UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        }
        
        // update time last checked to @now
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
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
        notificationContent.title = "You've gone over your " + String(UserDefaults.standard.getTime()) + " minute limit."
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
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
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
      
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        usageUpdatesLog.notice("Location update check")
        checkPhoneUsageDuringLocationUpdate()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didVisit visit: CLVisit) {
        usageUpdatesLog.notice("Visit check")
        checkPhoneUsageDuringLocationUpdate()
    }
    
    func locationManager(_ manager: CLLocationManager,  didFailWithError error: Error) {
        usageUpdatesLog.notice("Location manager error: \(error.localizedDescription)")
        locationManager.stopMonitoringVisits()
        return
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startMonitoringVisits()
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
    
}


