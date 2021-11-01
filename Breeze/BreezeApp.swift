//
//  BreezeApp.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/13/21.
//

import SwiftUI
import UserNotifications

@available(iOS 15.0, *)
@main
struct BreezeApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var appsToTrackHaveBeenSelected = false

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.requestNotificationAuthorization()
        UIApplication.shared.applicationIconBadgeNumber = 0
        sendNotification()
        return true
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
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        notificationContent.badge = NSNumber(value: 3)
        
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
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
