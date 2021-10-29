//
//  DeviceActivityMonitor.swift
//  Breeze
//
//  Created by Sabrina Jain on 10/27/21.
//

import Foundation
import SwiftUI
import DeviceActivity
import ManagedSettings

@available(iOS 15.0, *)
class deviceActivityMonitorForTrackingScreenTime : DeviceActivityMonitor {
    
    let store = ManagedSettingsStore()
    var applications: Set<Application>
    var categories: Set<ActivityCategory>
    var webDomains: Set<WebDomain>
    var applicationDailyEvents: [String?: DeviceActivityEvent] = [:]
    
    init (applications: Set<Application>, categories: Set<ActivityCategory>, webDomains: Set<WebDomain>) {
        self.applications = applications
        self.categories = categories
        self.webDomains = webDomains
        for (application) in applications {
            var applicationTokens = Set<ApplicationToken>()
            //will abort if application token is nil
            applicationTokens.insert(application.token!)
            self.applicationDailyEvents[application.localizedDisplayName] = DeviceActivityEvent(applications: applicationTokens, categories: Set<Token<ActivityCategory>>(), webDomains: Set<Token<WebDomain>>(), threshold: DateComponents())
        }
    }
    
    // TODO: Reset tracking interval every day at 00:00
    
}
