//
//  DeviceStore.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/2/21.
//

import Foundation
import RealmSwift

final class DeviceStore: ObservableObject {
  private var deviceResults: Results<DeviceDB>

  init(realm: Realm) {
    deviceResults = realm.objects(DeviceDB.self)
  }

  var devices: [Device] {
    deviceResults.map(Device.init)
  }

}

// CRUD Actions
extension DeviceStore {
    func create(timeInMinutes: Int) {
    objectWillChange.send()

    do {
      let realm = try Realm()

      let deviceDB = DeviceDB()
        
      deviceDB.id = UUID().hashValue
      deviceDB.points = 0
      deviceDB.streak = 0
      deviceDB.timeInMinutes = timeInMinutes

      try realm.write {
        realm.add(deviceDB)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }

  func update(id: Int, points: Int, streak: Int, timeInMinutes: Int, blockedApps:[String]) {
    objectWillChange.send()
      
    do {
      let realm = try Realm()
      try realm.write {
        realm.create(
          DeviceDB.self,
          value: [
            "id": id,
            "points": points,
            "streak": streak,
            "timeInMinutes": timeInMinutes,
            "blockedApps": blockedApps
          ],
          update: .modified)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }

  func delete(id: Int) {
    objectWillChange.send()
    
    guard let deviceDB = deviceResults.first(
      where: { $0.id == id})
      else { return }

    do {
      let realm = try Realm()
      try realm.write {
        realm.delete(deviceDB)
      }
    } catch let error {
      // Handle error
      print(error.localizedDescription)
    }
  }
}
