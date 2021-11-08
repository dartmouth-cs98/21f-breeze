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
        
        var activities: [DeviceActivityName: DeviceActivityEvent.Name] = [:]
        //var events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [:]
        
        
        for applicationToken in MyModel().retrieveSelection().applicationTokens {
            var indivApplicationTokenSet = Set<ApplicationToken>()
            //will abort if application token is nil
            indivApplicationTokenSet.insert(applicationToken)
            let events = [.discouraged: DeviceActivityEvent(
                applications: indivApplicationTokenSet,
                categories: Set<ActivityCategoryToken>(),
                webDomains: Set<WebDomainToken>(),
                threshold: DateComponents(second: 5))]
            
            
            // See below to try to figure out how to indivdualize app tracking
            /*
            print(newEvent.includesAllActivity)
            let uniqueApplicationString: String = applicationToken.hashValue.description
            print(uniqueApplicationString)
            let newName = DeviceActivityEvent.Name.init(rawValue: uniqueApplicationString)
            let newActivity = DeviceActivityName.init(rawValue: uniqueApplicationString)
            events[(.getTheEvent(uniqueEventName: uniqueApplicationString) ?? .discouraged)] = newEvent
            activities[newActivity] = newName
             */
        }
        
        print(events.count)
        
        let center = DeviceActivityCenter()
        do {
            print("Try to start monitoring...")
            /*for activity in activities.keys {
                let nameOfEvent = activities[activity]
                let event = events[nameOfEvent!]
                var placeholderDict : [DeviceActivityEvent.Name: DeviceActivityEvent] = [:]
                placeholderDict[nameOfEvent!] = event
             */
            try center.startMonitoring(.daily, during: schedule, events: events)
            
            
        } catch {
            print("Error monitoring schedule: ", error)
        }
        
    }
}
