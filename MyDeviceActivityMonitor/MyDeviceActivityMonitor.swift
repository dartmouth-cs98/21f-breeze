//
//  DeviceActivityMonitor.swift
//  MyDeviceActivityMonitor
//
//  Created by Sabrina Jain on 11/5/21.
//

import Foundation
import DeviceActivity
import ManagedSettings


class MyDeviceActivityMonitor: DeviceActivityMonitor {
    
    let applications = UserDefaults(suiteName: "group.BreezeTakeABreak")?.object(forKey: "applications")
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        print("intervalDidStart")
        super.intervalDidStart(for: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        print("intervalDidEnd")
        super.intervalDidEnd(for: activity)
    }

    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){
        print("eventDidReachThreshold")
        super.eventDidReachThreshold(event, activity: activity)
    }
    
}
