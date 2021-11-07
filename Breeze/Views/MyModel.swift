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
let defaults = UserDefaults.init(suiteName: "group.BreezeTakeABreak")

@available(iOS 15.0, *)
class MyModel: ObservableObject {
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
    }
    
    class var shared: MyModel {
        return _MyModel
    }
    
    func saveApplications(applications: Set<Application>) {
        defaults?.set(applications, forKey: "applications")
        print("Saved! Yay!")
    }
    
}
