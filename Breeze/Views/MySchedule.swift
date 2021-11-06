//
//  MySchedule.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/4/21.
//

import Foundation
import SwiftUI
import DeviceActivity
import FamilyControls
import ManagedSettings

// The Device Activity name is how to reference the activity from within the extension
@available(iOS 15.0, *)
extension DeviceActivityName {
    static let daily = Self("daily")
}

@available(iOS 15.0, *)
extension DeviceActivityEvent.Name {
    static let discouraged = Self("discouraged")
}

// The Device Activity schedule represents the time bounds in which my extension will monitor for activity
@available(iOS 15.0, *)
let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 23, minute: 59),
    repeats: true
)

@available(iOS 15.0, *)
class MySchedule {
    
    static public func setSchedule() {
        print("Setting schedule...")
        print("Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)
        
        var events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [:]
        
        for application in MyModel.shared.selectionToDiscourage.applicationTokens {
            var indivApplicationTokenSet = Set<ApplicationToken>()
            //will abort if application token is nil
            indivApplicationTokenSet.insert(application)
            let newEvent = DeviceActivityEvent(
                applications: indivApplicationTokenSet,
                threshold: DateComponents(minute: 5)
            )
            events[.discouraged] = newEvent
        }
        
        let center = DeviceActivityCenter()
        do {
            print("Try to start monitoring...")
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error monitoring schedule: ", error)
        }
        
    }
}
