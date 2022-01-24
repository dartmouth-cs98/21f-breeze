//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import UserNotifications
import FamilyControls
import BackgroundTasks
import Firebase
import UIKit

@available(iOS 15.0, *)

@main
struct BreezeApp: App {
    
    @AppStorage("hasntFinishedSetup") var hasntFinishedSetup: Bool = true
    @AppStorage("hasntExitedEndOfSetUpView") var hasntExitedEndOfSetUpView: Bool = true
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var appsToTrackHaveBeenSelected = false
    @StateObject var model = MyModel.shared
    

    var body: some Scene {
        
        WindowGroup {
              if hasntExitedEndOfSetUpView {
                  if hasntFinishedSetup {
                      TimeLimitInstructionsView()
                  } else {
                      InstructionsView()
                  }
                
              } else {
                ContentView().environmentObject(model)
              }
        }
        
    }
}

@available(iOS 15.0, *)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let backgroundTaskID = "com.breeze.CheckPhoneUsage"
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
            
        FirebaseApp.configure()
        // set this class as the notification delegate
        userNotificationCenter.delegate = self
                    
        //request authorization to use notifications
        self.requestNotificationAuthorization()
            
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
            
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self

        
        // Will fail with an error code of 2 on simulator since not signed into iCloud w/child's account
        AuthorizationCenter.shared.requestAuthorization { result in
                    // The request can either result in success or failure
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        print("Error for Family Controls: \(error)")
                    }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let token = deviceToken.reduce("") { $0 + String(format: "%02.2hhx", $1) }
      print("registered for notifications", token)
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

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("In")
        completionHandler()

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
        print("Checking phone usage")
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
    }
}
