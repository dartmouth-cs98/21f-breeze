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
import FamilyControls


class MyDeviceActivityMonitor: DeviceActivityMonitor {
    
    let applications = UserDefaults(suiteName: "group.BreezeTakeABreak")?.object(forKey: "applications")
    let userNotificationCenter = UNUserNotificationCenter.current()
    let selection : FamilyActivitySelection = MyModel().retrieveSelection()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        print("intervalDidStart")
        print(activity.rawValue)
        super.intervalDidStart(for: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        print("intervalDidEnd")
        super.intervalDidEnd(for: activity)
    }

    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name, activity:DeviceActivityName){
        print("eventDidReachThreshold")
        super.eventDidReachThreshold(event, activity: activity)
        sendNotification(activity: activity)
        NSLog("%@", event.rawValue)
        NSLog("This event reached its threshold: %@", activity.rawValue)
        
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
    }
    
    func sendNotification(activity: DeviceActivityName) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "You've hit your time limit on " + activity.rawValue
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
