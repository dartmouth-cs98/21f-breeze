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
    
    func saveSelection () {
        defaults?.set(try? PropertyListEncoder().encode(selectionToDiscourage), forKey:"selection")
    }
    
    func retrieveSelection () -> FamilyActivitySelection {
        if let data = defaults?.value(forKey:"selection") as? Data {
            let selection = (try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data))!
            return selection
        }
        return FamilyActivitySelection()
    }
    
}
