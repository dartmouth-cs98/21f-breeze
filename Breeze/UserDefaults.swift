//
//  UserDefaults.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/4/21.
//

import Foundation

extension UserDefaults{

    func setPoints(value: Int) {
        set(value, forKey: UserDefaultsKeys.points.rawValue)
    }

    func getPoints()-> Int {
        return integer(forKey: UserDefaultsKeys.points.rawValue)
    }

    func setStreak(value: Int){
        set(value, forKey: UserDefaultsKeys.streak.rawValue)
    }

    func getStreak() -> Int{
        return integer(forKey: UserDefaultsKeys.streak.rawValue)
    }
    
    func setTime(value: Int){
        set(value, forKey: UserDefaultsKeys.timeInMinutes.rawValue)
    }

    func getTime() -> Int{
        return integer(forKey: UserDefaultsKeys.timeInMinutes.rawValue)
    }
}

enum UserDefaultsKeys : String {
    case points
    case streak
    case timeInMinutes
}
