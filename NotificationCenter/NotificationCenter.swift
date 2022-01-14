//
//  NotificationCenter.swift
//  NotificationCenter
//
//  Created by John Weingart on 1/13/22.
//

import Foundation
import UserNotifications

public class NotificationCenter {

    var userNotificationCenter: UNUserNotificationCenter
    
    public init () {
        userNotificationCenter = UNUserNotificationCenter.current()
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
        notificationContent.title = "You've hit your time limit on BAD_APP"
        notificationContent.body = "Click to play a game in Breeze, and earn a reward"
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
