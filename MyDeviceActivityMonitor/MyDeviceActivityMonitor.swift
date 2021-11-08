//
//  DeviceActivityMonitor.swift
//  MyDeviceActivityMonitor
//
//  Created by Sabrina Jain on 11/5/21.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls


class MyDeviceActivityMonitor: DeviceActivityMonitor {
    
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
        super.eventDidReachThreshold(event, activity: activity)
        NSLog("%@", event.rawValue)
        NSLog("This event reached its threshold: %@", activity.rawValue)
        
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
    }
    
}
