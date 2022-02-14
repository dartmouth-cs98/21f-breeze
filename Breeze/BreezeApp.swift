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
        checkPhoneUsageBeforeLocking()
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        log.notice("Phone is unlocking")
        UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
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
        completionHandler()
        //TO-DO: HANDLE NOTIFICATION CLICKS - tap, snooze, decline, and (maybe) adjust Breeze settings button. And, add statistics for this.
        UserDefaults.standard.setExistsOutstandingNotification(value: false)
        UserDefaults.standard.incrementStreak()
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
    
    func sendNotification() {
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Accept",
              options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: [])
        
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "OVER_TIME_LIMIT",
              actions: [acceptAction, declineAction],
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
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        self.userNotificationCenter.add(request) { (error) in
            if let error = error {
                self.log.error("Notification error: \(String(describing: error))")
            }
        }
        UserDefaults.standard.addNotificationSent() //add this to stats
        
        if (UserDefaults.standard.existsOutstandingNotification()) {
            UserDefaults.standard.resetStreak()
        }
        else {
            UserDefaults.standard.setExistsOutstandingNotification(value: true)
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
                usageUpdatesLog.notice("User is above their chosen time limit, sending a notification to play Breeze")
                sendNotification()
                UserDefaults.standard.resetCurrentPhoneUsage()
            }
        } else {
            usageUpdatesLog.notice("Protected data is not available")
            UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        }
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
    }
    
    func checkPhoneUsageBeforeLocking() {
        usageUpdatesLog.notice("Checking phone usage before locking and updating statistics")
        UserDefaults.standard.checkDayRollover()

        if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
            usageUpdatesLog.notice("Protected data was previously available - adding this time interval to total phone usage")
            UserDefaults.standard.addIntervalToCurrentPhoneUsage()
        } else {
            usageUpdatesLog.notice("Protected data was not previously available - time interval not captured")
        }
        if (UserDefaults.standard.isAboveTimeLimit()) {
            usageUpdatesLog.notice("User is above their chosen time limit, sending a notification to play Breeze")
            sendNotification()
            UserDefaults.standard.resetCurrentPhoneUsage()
        }
        UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
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
    
}

