//
//  DeviceForm.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/2/21.
//

import Foundation
import RealmSwift

class DeviceForm: ObservableObject {
  @Published var points = 0
  @Published var streak = 0
  @Published var blockedApps = RealmSwift.List<String>()
  @Published var timeInMinutes = 0


  init() { }

  init(_ deviceDB: DeviceDB) {
      points = deviceDB.points
      streak = deviceDB.streak
      blockedApps = deviceDB.blockedApps
      timeInMinutes = deviceDB.timeInMinutes
   }
}
