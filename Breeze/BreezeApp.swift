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
                      FamilyActivityPickerView().environmentObject(model)
                  } else {
                      EndOfSetUpView()
                  }
                
              } else {
                ContentView().environmentObject(model)
              }
        }
        
    }
}

@available(iOS 15.0, *)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()
    let backgroundTaskID = "com.breeze.CheckPhoneUsage"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) ->
        Bool {
        // set this class as the notification delegate
        userNotificationCenter.delegate = self
                    
        //request authorization to use notifications
        self.requestNotificationAuthorization()

        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Test: \(response.notification.request.identifier)")
        print("Action taken: \(response.actionIdentifier)")
        completionHandler()
    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let token = deviceToken.reduce("") { $0 + String(format: "%02.2hhx", $1) }
      print("registered for notifications", token)
    }

    
    func application(_ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        checkPhoneUsage()
        completionHandler(.noData) // Attempting to trick system into prioritizing app as much as possible
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
        if UIApplication.shared.isProtectedDataAvailable {
            if (UserDefaults.standard.getPreviousProtectedDataStatus()) {
                UserDefaults.standard.addIntervalToCurrentPhoneUsage()
            } else {
                UserDefaults.standard.setPreviousProtectedDataStatus(value: true)
            }
            if (UserDefaults.standard.isAboveTimeLimit()) {
                // send local notification to user
                sendNotification()
                UserDefaults.standard.resetCurrentPhoneUsage()
            }
        } else {
            UserDefaults.standard.setPreviousProtectedDataStatus(value: false)
        }
    }
}
