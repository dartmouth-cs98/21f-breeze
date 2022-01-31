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
    }
    
    func setLastDatePlayedToToday() {
        set(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastDatePlayed.rawValue)
    }
    
    func getDaysFromLastPlay() -> Int {
        let calender = Calendar.current
        let date1 = calender.startOfDay(for: Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastDatePlayed.rawValue)))
        let date2 = calender.startOfDay(for: Date())
        let components = calender.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
        
    }
    
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
    
    func getPreviousProtectedDataStatus()-> Bool {
        return bool(forKey: UserDefaultsKeys.previousProtectedDataStatus.rawValue)
    }

    func setPreviousProtectedDataStatus(value: Bool){
        set(value, forKey: UserDefaultsKeys.previousProtectedDataStatus.rawValue)
    }
    
    func getSecondsElapsedFromLastTimeProtectedDataStatusChecked()-> Int {
        let calender = Calendar.current
        
        let date1 = Date(timeIntervalSince1970: double(forKey: UserDefaultsKeys.lastTimeProtectedDataStatusChecked.rawValue))
        let date2 = Date()
        let components = calender.dateComponents([.second], from: date1, to: date2)
        return components.second ?? 0
    }

    func setLastTimeProtectedDataStatusChecked(){
        set(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastTimeProtectedDataStatusChecked.rawValue)
    }
    
    func getCurrentPhoneUsage() -> Int {
        return integer(forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
    }
    
    func addIntervalToCurrentPhoneUsage() {
        let secondsElapsed = getSecondsElapsedFromLastTimeProtectedDataStatusChecked()
        print("Seconds elapsed since last check: " + String(secondsElapsed))
        let currentPhoneUsage = getCurrentPhoneUsage()
        set((currentPhoneUsage + Int(secondsElapsed)), forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
    }
    
    func resetCurrentPhoneUsage() {
        set(0, forKey: UserDefaultsKeys.currentPhoneUsage.rawValue)
        print("reset")
        print(getCurrentPhoneUsage())
    }
    
    func isAboveTimeLimit() -> Bool {
        let currentPhoneUsage = getCurrentPhoneUsage()
        print("Current phone usage (in seconds): " + String(currentPhoneUsage))
        print("Current phone usage (in seconds): " + String(currentPhoneUsage/60))
        
        let timeLimit = getTime()
        print("Time limit: " + String(timeLimit))
        if ((currentPhoneUsage/60) >= timeLimit && timeLimit > 0) {
            return true
        } else {
            return false
        }
    }
    
    func islandLevelUp(value: Int) {
        if (value == 1) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island1.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island1.rawValue)
        }
        else if (value == 2) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island2.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island2.rawValue)
        }
        else if (value == 3) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island3.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island3.rawValue)
        }
        else if (value == 4) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island4.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island4.rawValue)
        }
        else if (value == 5) {
            var currLevel: Int = integer(forKey: UserDefaultsKeys.island5.rawValue)
            if currLevel < 5 {
                currLevel += 1
            }
            set(currLevel, forKey: UserDefaultsKeys.island5.rawValue)
        }
    }
    
    func islandGetLevel(value: Int) -> Int {
        if (value == 1) {
            return integer(forKey: UserDefaultsKeys.island1.rawValue)
        }
        else if (value == 2) {
            return integer(forKey: UserDefaultsKeys.island2.rawValue)
        }
        else if (value == 3) {
            return integer(forKey: UserDefaultsKeys.island3.rawValue)
        }
        else if (value == 4) {
            return integer(forKey: UserDefaultsKeys.island4.rawValue)
        }
        else if (value == 5) {
            return integer(forKey: UserDefaultsKeys.island5.rawValue)
        }
        else {
            return 0
        }
    }
    
    func resetMap() {
        set(1, forKey: UserDefaultsKeys.island1.rawValue)
        set(1, forKey: UserDefaultsKeys.island2.rawValue)
        set(1, forKey: UserDefaultsKeys.island3.rawValue)
        set(1, forKey: UserDefaultsKeys.island4.rawValue)
        set(1, forKey: UserDefaultsKeys.island5.rawValue)
    }
    
}

enum UserDefaultsKeys : String {
    case points
    case streak
    case timeInMinutes
    case endedGame
    case setup
    case numClicks
    case lastDatePlayed
    case previousProtectedDataStatus
    case lastTimeProtectedDataStatusChecked
    case currentPhoneUsage
    case island1
    case island2
    case island3
    case island4
    case island5
    
}
