//
//  DeviceActivityMonitor.swift
//  MyDeviceActivityMonitor
//
//  Created by Sabrina Jain on 11/5/21.
//

import Foundation
import DeviceActivity
import ManagedSettings
import UserNotifications


class MyDeviceActivityMonitor: DeviceActivityMonitor {
    
    let applications = UserDefaults(suiteName: "group.BreezeTakeABreak")?.object(forKey: "applications")
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        print("intervalDidStart")
        super.intervalDidStart(for: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        print("intervalDidEnd")
        super.intervalDidEnd(for: activity)
        sendNotification()
    }

    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){
        print("eventDidReachThreshold")
        super.eventDidReachThreshold(event, activity: activity)
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "You've hit your time limit!"
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
