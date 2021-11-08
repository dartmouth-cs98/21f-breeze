//
//  MyModel.swift
//  Breeze
//
//  Created by Sabrina Jain on 11/4/21.
//

import Foundation
import FamilyControls
import ManagedSettings

@available(iOS 15.0, *)
private let _MyModel = MyModel()
let defaults = UserDefaults.init(suiteName: "JQ28K6Y7JE.group.BreezeTakeABreak")

@available(iOS 15.0, *)
class MyModel: ObservableObject {
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
    }
    
    class var shared: MyModel {
        return _MyModel
    }
    
    func archiveApplications(applications:[Application]) -> Data? {
        do {
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: applications as NSArray, requiringSecureCoding: false)
            print("Archived!")
            return archivedObject
        } catch {
            print(error)
        }
        return nil
    }
    
    func saveApplications(applications:[Application]) {
        let archivedObject = archiveApplications(applications: applications)
        defaults?.set(archivedObject, forKey: "applications")
        defaults?.synchronize()
        let listOfRetrieved: [Application] = retrieveApplications() ?? []
        //print(listOfRetrieved.count)
        print("Saved! Yay!")
    }
    
    func retrieveApplications() -> [Application]? {
        guard
            let unarchivedObject = defaults?.object(forKey: "applications") as? Data
        else {
            return nil
        }
        print("Unarchived!")
        do {
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? [Application] else {
                fatalError("loadApplications - Can't get Array")
            }
            return array
        } catch {
            fatalError("loadApplications - Can't encode data: \(error)")
        }
    }
    
}
