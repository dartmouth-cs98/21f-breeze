//
//  Device.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/1/21.
//

import Foundation
import RealmSwift

class DeviceDB: Object {
    @objc dynamic var id = 0
    @objc dynamic var streak = 0
    @objc dynamic var points = 0
    //var blockedAppsList = RealmSwift.List<String>() // TODO: change "String" to correct data type for blocked apps in all instances
    @objc dynamic var timeInMinutes = 0
    
    var blockedApps = RealmSwift.List<String>() //{ Array(blockedAppsList) } // get only
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
