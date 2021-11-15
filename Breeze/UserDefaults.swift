//
//  UserDefaults.swift
//  Breeze
//
//  Created by Laurel Dernbach on 11/4/21.
//

import Foundation

// getters and setters for stander UserDefaults data
extension UserDefaults{

    // example usage:
    // UserDefaults.standard.setPoints(value: 90)
    func setPoints(value: Int) {
        var currPoints: Int = integer(forKey: UserDefaultsKeys.points.rawValue)
        currPoints += value
        set(currPoints, forKey: UserDefaultsKeys.points.rawValue)
    }

    // example usage:
    // UserDefaults.standard.getPoints()
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
    
    func setSetupBool(value: Bool) {
        set(value, forKey: UserDefaultsKeys.setup.rawValue)
    }

    func isSetup()-> Bool {
        return bool(forKey: UserDefaultsKeys.setup.rawValue)
    }
    
    func setGameStatus(value: Bool) {
        set(value, forKey: UserDefaultsKeys.endedGame.rawValue)
    }
    
    func isEnded() -> Bool {
        return bool(forKey: UserDefaultsKeys.endedGame.rawValue)

    // example usage:
    // UserDefaults.standard.setPoints(value: 90)
    func setNumClicks(value: Int) {
        set(value, forKey: UserDefaultsKeys.numClicks.rawValue)
    }

    // example usage:
    // UserDefaults.standard.getPoints()
    func getNumClicks()-> Int {
        return integer(forKey: UserDefaultsKeys.numClicks.rawValue)

    }
}

enum UserDefaultsKeys : String {
    case points
    case streak
    case timeInMinutes
    case endedGame
    case numClicks
}
