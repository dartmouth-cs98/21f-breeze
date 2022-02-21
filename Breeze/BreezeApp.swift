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

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "edu.dartmouth.breeze.CheckPhoneUsage", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        log.notice("Received notification - Next will check phone usage")
        checkPhoneUsage()
        if let messageID = userInfo[gcmMessageIDKey] {
            log.notice("Message ID: \(String(describing: messageID))")
        }
        
        if let value = userInfo["some-key"] as? String {
               print(value) // output: "some-value"
        }
        log.notice("\(String(describing: userInfo))")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        log.notice("Phone is locking")
        userNotificationCenter.removeAllPendingNotificationRequests()
        checkPhoneUsageBeforeLocking()
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        log.notice("Phone is unlocking")
        print("curr phone usage:" + String(UserDefaults.standard.getCurrentPhoneUsage()))
        userNotificationCenter.removeAllPendingNotificationRequests()
        userNotificationCenter.removeAllDeliveredNotifications()
        print("streak: \(UserDefaults.standard.getStreak())")
        
        if (UserDefaults.standard.getCurrentPhoneUsage() >= (UserDefaults.standard.getTime() * 60) || UserDefaults.standard.getSendNotificationOnUnlock()) {
            scheduleNotification(overTimeLimit: true, identity: "overTimeLimit") // make it for 5 seconds
            UserDefaults.standard.resetCurrentPhoneUsage()
        }
        scheduleNotification()
        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
        UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
        userNotificationCenter.getPendingNotificationRequests { (notifications) in
            print(notifications)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
        log.notice("\(String(describing: userInfo))")
        completionHandler([])
    }

    
    //NOTIFICATION CLICKED
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        log.notice("\(String(describing: userInfo))")
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
    
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "edu.dartmouth.breeze.CheckPhoneUsage")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
           usageUpdatesLog.error("Could not schedule app refresh: \(String(describing: error))")
       }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let checkPhoneUsageOperation = BlockOperation {
            self.checkPhoneUsage()
        }
        
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }

       // Inform the system that the background task is complete
       // when the operation completes.
        checkPhoneUsageOperation.completionBlock = {
            let success = true
            if success {
                self.usageUpdatesLog.notice("Background task ran and finished")
            }
            task.setTaskCompleted(success: success)
        }

       // Start the operation.
        queue.addOperation(checkPhoneUsageOperation)
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
        notificationContent.title = "You've gone over " + String(UserDefaults.standard.getTime()) + " minutes."
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
        var identifier = identity
        
        if (overTimeLimit) {
            print("here sending immediately")
            identifier = "immediate"
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
        } else {
            print("notification scheduled for \((UserDefaults.standard.getTime() * 60) - UserDefaults.standard.getCurrentPhoneUsage())")
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(((UserDefaults.standard.getTime() * 60) - UserDefaults.standard.getCurrentPhoneUsage())),
                                                            repeats: false)
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
        
    func checkPhoneUsage() {
        usageUpdatesLog.notice("Checking phone usage and updating statistics")
        UserDefaults.standard.checkDayRollover()
        if UIApplication.shared.isProtectedDataAvailable {
            usageUpdatesLog.notice("Protected data is available")
            if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
                usageUpdatesLog.notice("Protected data was previously available - adding this time interval to total phone usage")
                UserDefaults.standard.addIntervalToCurrentPhoneUsage()
            } else {
                usageUpdatesLog.notice("Protected data was not previously available - user started using their phone during this time interval")
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
            }
            if (UserDefaults.standard.isAboveTimeLimit()) {
                usageUpdatesLog.notice("User is above their chosen time limit,  notification should be sent to play Breeze")
                UserDefaults.standard.resetCurrentPhoneUsage()
                userNotificationCenter.removeAllDeliveredNotifications()
            }
        } else {
            usageUpdatesLog.notice("Protected data is not available")
            UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        }
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
    }
    
    func checkPhoneUsageBeforeLocking() {
        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
        usageUpdatesLog.notice("Checking phone usage before locking and updating statistics")
        UserDefaults.standard.checkDayRollover()

        var count = 0
        
        
        if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
            usageUpdatesLog.notice("Protected data was previously available - adding this time interval to total phone usage")
            UserDefaults.standard.addIntervalToCurrentPhoneUsage()
        } else {
            usageUpdatesLog.notice("Protected data was not previously available - time interval not captured")
        }
        
        UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
        
        userNotificationCenter.getDeliveredNotifications { (notifications) in
            count = notifications.count
            print("outstanding notification count: \(count)")
            if (count > 0) {
                UserDefaults.standard.resetStreak()
                //above time limit and outstanding notification
                if(UserDefaults.standard.isAboveTimeLimit()) {
                    let timeSinceNotification = UserDefaults.standard.getCurrentPhoneUsage() - (UserDefaults.standard.getTime() * 60)
                    print(timeSinceNotification)
                    if (timeSinceNotification > (UserDefaults.standard.getTime() * 60)) {
                        UserDefaults.standard.setSendNotificationOnUnlock(value: true)
                        UserDefaults.standard.resetCurrentPhoneUsage()
                        self.usageUpdatesLog.notice("User is above their chosen time limit, will send a notification to play Breeze next time they open their phone")
                    }
                    else {
                        UserDefaults.standard.setSendNotificationOnUnlock(value: false)
                        UserDefaults.standard.setCurrentPhoneUsage(value: timeSinceNotification)
                    }
                }
            }
            
            //no outstanding notification and above time limit
            else if (UserDefaults.standard.isAboveTimeLimit()) {
                UserDefaults.standard.setSendNotificationOnUnlock(value: true)
                UserDefaults.standard.resetCurrentPhoneUsage()
                self.usageUpdatesLog.notice("User is above their chosen time limit, will send a notification to play Breeze next time they open their phone")
            }
            
            //no outstanding notifications and below time limit
            else {
                UserDefaults.standard.setSendNotificationOnUnlock(value: false)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        usageUpdatesLog.notice("Location update check")
        checkPhoneUsage()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didVisit visit: CLVisit) {
        usageUpdatesLog.notice("Visit check")
        checkPhoneUsage()
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


