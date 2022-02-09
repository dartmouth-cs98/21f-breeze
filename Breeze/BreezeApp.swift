//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import UserNotifications
import BackgroundTasks
import Firebase
import UIKit
import Foundation
import CoreLocation

@available(iOS 15.0, *)

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

@available(iOS 15.0, *)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, CLLocationManagerDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    let backgroundTaskID = "com.breeze.CheckPhoneUsage"
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
            
        // set this class as the notification delegate
        userNotificationCenter.delegate = self
        FirebaseApp.configure()
                    
        //request authorization to use notifications
        self.requestNotificationAuthorization()
            
        // request authorization to track updates
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        locationManager.startMonitoringSignificantLocationChanges()
        

            
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()

        if (UIApplication.shared.isRegisteredForRemoteNotifications) {
            print("This application on this device is registered for remote notifications")
        } else {
            print("This application on this device is NOT registered for remote notifications")
        }
            
        Messaging.messaging().delegate = self
            
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "edu.dartmouth.breeze.CheckPhoneUsage", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("called")
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken;

      print("Device Token: \(token)")
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("Received notification - Next will check phone usage")
        checkPhoneUsage()
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let value = userInfo["some-key"] as? String {
               print(value) // output: "some-value"
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        
      // TODO: If necessary send token to application server.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
        print("In")
        print(userInfo)
        completionHandler([])
    }

    
    //NOTIFICATION CLICKED
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("In")
        completionHandler()
    }
    
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "edu.dartmouth.breeze.CheckPhoneUsage")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
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
                print("Background task ran and finished")
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
                print("Error: ", error)
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
        notificationContent.title = "You've gone over " + String(UserDefaults.standard.getTime()) + "minutes."
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
                print("Notification Error: ", error)
            }
        }
    }
        
    func checkPhoneUsage() {
        print("Checking phone usage and updating statistics")
        UserDefaults.standard.checkDayRollover
        if UIApplication.shared.isProtectedDataAvailable {
            print("Protected data is available")
            if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
                print("Protected data was previously available - adding this time interval to total phone usage")
                UserDefaults.standard.addIntervalToCurrentPhoneUsage()
            } else {
                print("Protected data was not previously available - user started using their phone during this time interval")
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
            }
            if (UserDefaults.standard.isAboveTimeLimit()) {
                print("User is above their chosen time limit, sending a notification to play Breeze")
                sendNotification()
                UserDefaults.standard.resetCurrentPhoneUsage()
            }
        } else {
            print("Protected data is not available")
            UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        }
        UserDefaults.standard.setLastTimeProtectedDataStatusChecked()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkPhoneUsage()
    }
    
    func locationManager(_ manager: CLLocationManager,  didFailWithError error: Error) {
        print(error.localizedDescription)
        locationManager.stopMonitoringVisits()
        return
    }
}

