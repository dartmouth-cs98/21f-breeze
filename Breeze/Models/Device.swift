//
//  Device.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/2/21.
//

import SwiftUI
import RealmSwift

struct Device: Identifiable {
  let id: Int
  let points: Int
  let streak: Int
  let blockedApps: [String]
  let timeInMinutes: Int
}

// Convenience init
extension Device {
  init(deviceDB: DeviceDB) {
    id = deviceDB.id
    points = deviceDB.points
    streak = deviceDB.streak
    blockedApps  = deviceDB.blockedApps
    timeInMinutes = deviceDB.timeInMinutes
  }
}
