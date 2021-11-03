//
//  UserSettings.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/3/21.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var points: Int {
        didSet {
            UserDefaults.standard.set(points, forKey: "points")
        }
    }
    
    @Published var streak: Int {
        didSet {
            UserDefaults.standard.set(streak, forKey: "streak")
        }
    }
    
    @Published var timeInMinutes: Int {
        didSet {
            UserDefaults.standard.set(timeInMinutes, forKey: "timeInMinutes")
        }
    }
    
    init() {
        self.points = 0
        self.streak = 0
        self.timeInMinutes = 0  }
}
